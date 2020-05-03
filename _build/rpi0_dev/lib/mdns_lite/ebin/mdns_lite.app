{application,mdns_lite,
             [{applications,[kernel,stdlib,elixir,logger,dns]},
              {description,"A simple, limited, no frills implementation of an mDNS server"},
              {modules,['Elixir.MdnsLite','Elixir.MdnsLite.Application',
                        'Elixir.MdnsLite.Application.RuntimeSupervisor',
                        'Elixir.MdnsLite.Configuration',
                        'Elixir.MdnsLite.Configuration.State',
                        'Elixir.MdnsLite.InetMonitor',
                        'Elixir.MdnsLite.InetMonitor.State',
                        'Elixir.MdnsLite.Query','Elixir.MdnsLite.Responder',
                        'Elixir.MdnsLite.Responder.State',
                        'Elixir.MdnsLite.ResponderSupervisor',
                        'Elixir.MdnsLite.Utilities',
                        'Elixir.MdnsLite.VintageNetMonitor',
                        'Elixir.MdnsLite.VintageNetMonitor.State']},
              {registered,[]},
              {vsn,"0.6.3"},
              {mod,{'Elixir.MdnsLite.Application',[]}}]}.