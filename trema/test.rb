class Hub < Trema::Controller

    # Evet: start
    def start(_args)
      logger.info "#{name} started."
    end
  
  
    def switch_ready(datapath_id)
      logger.info "Hello #{datapath_id.to_hex}!"
    end
  
  
    # Event: Packet_in
    def packet_in( datapath_id, message )
      logger.info "received a packet_in"
      logger.info "switch : #{ datapath_id }"
      logger.info "in_port: #{ message.in_port }"
      logger.info "src_addr: #{ message.source_mac }"
  
      if message.in_port == 1 then
        # loop block
        send_flow_mod_add(
          datapath_id,
            :match => Match.new( in_port: 1 ),
            :actions => SendOutPort.new(2),
            :priority => 100
        )
      end
  
      if message.in_port == 2 then
        # loop block
        send_flow_mod_add(
          datapath_id,
            :match => Match.new( in_port: 2 ),
            :actions => SendOutPort.new(1),
            :priority => 100
        )
      end
  
    end
  end