require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'

#CERT_PATH = '/opt/myCA/server/'
CERT_PATH = Dir.pwd

webrick_options = {
	        :Port               => 8443,
			:Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
			:DocumentRoot       => "/ruby/htdocs",
			:SSLEnable          => true,
			:SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
			:SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "my-server.crt")).read),
			:SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "my-server.key")).read),
			:SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

class MyServer  < Sinatra::Base
	    post '/' do
			"Hello, world!"
		end            
end

Rack::Handler::WEBrick.run MyServer, webrick_options
