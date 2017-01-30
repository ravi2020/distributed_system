require_relative 'data'
require_relative 'dsm'
require_relative 'server'
require_relative 'config'


port = ARGV[0].to_i
process_number = port % CONFIG['first_process_port']

distributed_data = Distributed::Data.new

# CONFIG['process_count'].times do |index|
#   fork do
dsm = Dsm.new(distributed_data.for_process(process_number), distributed_data.get_dd_index_mapping_with_original_data(process_number))
server = Server.new((CONFIG['first_process_port']+process_number), dsm)
server.accept_requests
# end
# end