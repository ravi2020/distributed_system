require_relative 'data'
require_relative 'dsm'
require_relative 'server'
require_relative 'config'

distributed_data = Distributed::Data.new

CONFIG['process_count'].times do |process_number|
  fork do
                  # 0  # [0,1]                                       { 0 : 0, 1: 1}
                  # 1  # [2,3]                                       { 0 : 2, 1: 3}
                  # 2  # [4,5]                                       { 0 : 4, 1: 5}
                  # 3  # [6,7,8]                                     { 0 : 6, 1: 7, 2: 8}
    dsm = Dsm.new(distributed_data.for_process(process_number), distributed_data.get_dd_index_mapping_with_original_data(process_number))
    server = Server.new((CONFIG['first_process_port']+process_number), dsm)
    server.accept_requests
  end
end