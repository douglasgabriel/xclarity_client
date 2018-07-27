require 'json-schema'

module XClarityClient
  class Schemas
    @remotefs = {
      "id"         => "create_remotefileserver_profile",
      "type"       => "object",
      "required"   => %w(address displayName port protocol),
      "properties" => {
        "address"      => {
          "type" => "string"
        },
        "displayName"  => {
          "type" => "string"
        },
        "keyComment"   => {
          "type" => "string"
        },
        "keyPassphras" => {
          "type" => "string"
        },
        "keyType"      => {
          "type" => "string"
        },
        "password"     => {
          "type" => "string"
        },
        "port"         => {
          "type" => "integer"
        },
        "protocol"     => {
          "type" => "string"
        },
        "serverId"     => {
          "type" => "string"
        },
        "username"     => {
          "type" => "string"
        }
      }
    }

    @hostplatforms = {
      "id"    => "deploy_osimage",
      "type"  => "array",
      "items" => {
        "type"       => "object",
        "required"   => %w(networkSettings selectedImage storageSettings uuid),
        "properties" => {
          "adusername"        => {
            "type" => "string"
          },
          "adpassword"        => {
            "type" => "string"
          },
          "configFileId"      => {
            "type" => "string"
          },
          "licenseKey"        => {
            "type" => "string"
          },
          "selectedImage"     => {
            "type" => "string"
          },
          "storageSettings"   => {
            "type" => "object"
          },
          "unattendFileId"    => {
            "type" => "string"
          },
          "uuid"              => {
            "type" => "string"
          },
          "windowsDomain"     => {
            "type" => "string"
          },
          "windowsDomainBlob" => {
            "type" => "string"
          },
          "networkSettings"   => {
            "type"       => "object",
            "properties" => {
              "dns1"         => {
                "type" => "string"
              },
              "dns2"         => {
                "type" => "string"
              },
              "gateway"      => {
                "type" => "string"
              },
              "hostname"     => {
                "type" => "string"
              },
              "ipAddress"    => {
                "type" => "string"
              },
              "mtu"          => {
                "type" => "integer"
              },
              "prefixLength" => {
                "type" => "string"
              },
              "selectedMAC"  => {
                "type" => "string"
              },
              "vlanId"       => {
                "type" => "string"
              }
            }
          }
        }
      }
    }

    @globalsettings = {
      "id"         => "set_globalsettings",
      "type"       => "object",
      "required"   => %w(activeDirectory
                         ipAssignment
                         isVLANMode
                         licenseKeys
                         credentials),
      "properties" => {
        "activeDirectory" => {
          "type" => "object"
        },
        "ipAssignment"    => {
          "type" => "string"
        },
        "isVLANMode"      => {
          "type" => "boolean"
        },
        "licenseKeys"     => {
          "type" => "object"
        },
        "deploySettings"  => {
          "type" => "string"
        },
        "credentials"     => {
          "type"  => "array",
          "items" => {
            "type"       => "object",
            "required"   => %w(type name password passwordChanged),
            "properties" => {
              "type"            => {
                "type" => "string"
              },
              "name"            => {
                "type" => "string"
              },
              "password"        => {
                "type" => "string"
              },
              "passwordChanged" => {
                "type" => "boolean"
              }
            }
          }
        }
      }
    }

    REQ_SCHEMA = {
      'deploy_osimage'                  => @hostplatforms,
      'set_globalsettings'              => @globalsettings,
      'create_remotefileserver_profile' => @remotefs
    }.freeze

    def self.validate_input(schema_name, data)
      x = JSON::Validator.fully_validate(Schemas::REQ_SCHEMA[schema_name], data)
      if !x.empty?
        errmsg = "input validation failed for data #{data}"
        $lxca_log.error(errmsg, '')
        x.each { |k| $lxca_log.error(k, '') }
        return nil
      else
        return 1
      end
    end

    # parameter name should be string
    def self.validate_input_parameter(name, value, exp_type)
      if !value.kind_of?(exp_type)
        errmsg = "invalid #{name} #{value},"\
                 " expected #{name} of type #{exp_type}"
        $lxca_log.error(errmsg, '')
        return nil
      else
        return 1
      end
    end
  end
end
