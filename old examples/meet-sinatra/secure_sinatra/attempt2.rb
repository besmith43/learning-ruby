#!/usr/bin/env ruby

require 'webrick'
require 'webrick/https'
require 'openssl'

CERT_PATH = Dir.pwd

pkey = cert = cert_name = nil
begin
  pkey =
	  OpenSSL::PKey::RSA.new(File.open(File.join(CERT_PATH, "my-server.key")).read)
  cert =
	  OpenSSL::X509::Certificate.new(File.open(File.join(CERT_PATH, "my_server.crt")).read)
rescue
  $stderr.puts "Switching to use self-signed certificate"
  cert_name = [ ["C","JP"], ["O","WEBrick.Org"], ["CN", "WWW"] ]
end


s=WEBrick::HTTPServer.new(

  :Port             => 8080,
  :Logger           => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
  :DocumentRoot     => "/usr/local/webrick/htdocs",
  :SSLEnable        => true,
  :SSLVerifyClient  => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate   => cert,
  :SSLPrivateKey    => pkey,
  :SSLCertName      => cert_name
)

s.start
