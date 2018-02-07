module XClarityClient
    class Connection
        def initialize(configuration)
            @configuration = configuration
        end

        def valid?()
        end

        # TODO: deve assumir o papel do close (serve para todos os tipos de autenticação)
        def invalidate()
        end

        # TODO: ver se há a necessidade de autenticar antes de mandar uma requisição
        #   caso dê para mandar apenas as credenciais no cabeçalho
        #   ver se faz sentido essa responsabilidade ser da conexão
        def open()
        end
    end
end