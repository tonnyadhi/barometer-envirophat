defmodule Barometer do
  alias ElixirALE.I2C

  @sealevel_pa 101325


  @doc """
  Put the BMP280 in normal mode and sample the temperature and
  pressure sensor at ultra high resolution.
  """
  def enable() do
    mode = 3  # normal
    osrs_t = 2 # x2 oversampling
    osrs_p = 5 # x16 oversampling
    ctrl_meas_register = 0xf4
    I2C.write(Barometer.I2C, <<ctrl_meas_register, osrs_t::size(3), osrs_p::size(3), mode::size(2)>>)
  end

  @doc """
  Take a raw measurement
  """
  def raw_temp_and_pressure() do
    <<pressure::size(20), _::size(4), temp::size(20), _::size(4)>> =
      I2C.write_read(Barometer.I2C, <<0xf7>>, 6)
    {temp, pressure}
  end

    @doc """
  Read the trimming parameters from the BMP280's non-volatile memory
  """
  def calibration() do
    <<dig_T1::little-unsigned-size(16),
      dig_T2::little-signed-size(16),
      dig_T3::little-signed-size(16),
      dig_P1::little-unsigned-size(16),
      dig_P2::little-signed-size(16),
      dig_P3::little-signed-size(16),
      dig_P4::little-signed-size(16),
      dig_P5::little-signed-size(16),
      dig_P6::little-signed-size(16),
      dig_P7::little-signed-size(16),
      dig_P8::little-signed-size(16),
      dig_P9::little-signed-size(16)>> =
      I2C.write_read(Barometer.I2C, <<0x88>>, 24)
    %{dig_T1: dig_T1,
      dig_T2: dig_T2,
      dig_T3: dig_T3,
      dig_P1: dig_P1,
      dig_P2: dig_P2,
      dig_P3: dig_P3,
      dig_P4: dig_P4,
      dig_P5: dig_P5,
      dig_P6: dig_P6,
      dig_P7: dig_P7,
      dig_P8: dig_P8,
      dig_P9: dig_P9}
  end

  def calculate_temp(raw_temp, cal) do
    var1 = (raw_temp/16384 - cal.dig_T1/1024) * cal.dig_T2
    var2 = (raw_temp/131072 - cal.dig_T1/8192) * (raw_temp/131072 - cal.dig_T1/8192) * cal.dig_T3
    (var1 + var2) / 5120
  end

  def calculate_temp_and_pressure(raw_temp, raw_pressure, cal) do
    temp = calculate_temp(raw_temp, cal)
    t_fine = temp * 5120

    var1 = t_fine/2 - 64000
    var2 = var1 * var1 * cal.dig_P6 / 32768
    var2 = var2 + var1 * cal.dig_P5 * 2
    var2 = var2 / 4 + cal.dig_P4 * 65536
    var1 = (cal.dig_P3 * var1 * var1 / 524288 + cal.dig_P2 * var1) / 524288
    var1 = (1 + var1/32768) * cal.dig_P1
    p = 1048576 - raw_pressure
    p = (p - (var2/4096)) * 6250/var1
    var1 = cal.dig_P9 * p * p / 2147483648
    var2 = p * cal.dig_P8 / 32768
    p = p + (var1 + var2 + cal.dig_P7) / 16

    {temp, p}
  end

  @doc """
  Read the temperature and pressure from the BMP280.

  Return Celsius and Pascals
  """
  def temp_and_pressure() do
    {raw_temp, raw_pressure} = raw_temp_and_pressure()
    cal = calibration()

    calculate_temp_and_pressure(raw_temp, raw_pressure, cal)
  end

  @doc """
  Read the temperature and pressure and return in US units.
  I.e., Fahrenheit and inches of mercury
  """
  def temp_and_pressure_us() do
    {t, p} = temp_and_pressure()
    {celsius_to_fahrenheit(t),
     pascals_to_inHg(p)}
  end

  @doc """
  Estimate the altitude in meters.
  """
  def altitude(p) do
    44330 * (1 - :math.pow(p / @sealevel_pa, 1/5.255))
  end

  def measure_all() do
    {t, p} = temp_and_pressure()
    altitude = altitude(p)

    %{temperature: t,
      pressure: p,
      altitude: altitude,
      units: :si}
  end

  def celsius_to_fahrenheit(t) do
    32 + 1.8 * t
  end

  def pascals_to_inHg(p) do
    p * 0.00029529983071445
  end

  def meters_to_feet(m), do: 3.2808399 *m

end
