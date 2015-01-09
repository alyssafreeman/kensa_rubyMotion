require 'base64'
require 'fileutils'

class DMConfig

    CONFIG_FILE = "dm_config"  #App-specific.  A config file we create and manage, stores our UI configuration...

    #These are TkVariables... Code typically references the .value attribute, as in account_name.value.
    # attr_accessor :account_name, :user_name, :password,
    #               :publisher, :product, :stream_type,
    #               :job_info, :job_uuid,  #User can enter Data URL or UUID as job_info.  We use either to set job_uuid.
    #               :data_dir, :consolidate_dir, :uncompress_data, :convert_csv, :data_span

    attr_accessor :output_file_name, :data_dir

    def initialize
        #Defaults.
        # @publisher = "twitter"
        # @product = "historical"
        # @stream_type = "track"
    end

    #Confirm a directory exists, creating it if necessary.
    def check_directory(directory)
        #Make sure directory exists, making it if needed.
        if not File.directory?(directory) then
            FileUtils.mkpath(directory) #logging and user notification.
        end
        directory
    end

    def save_config

        config = DMConfig.new
        config.output_file_name=@output_file_name.value
        config.data_dir=@data_dir.value

        #write to file
        File.open("dm_config", "wb") do |f|
            Marshal.dump(config,f)
        end
    end

    def get_config
        config = DMConfig.new

        if File.exist?(CONFIG_FILE) then

            begin
                #Load from Config file.
                File.open(CONFIG_FILE, "rb") do |f|
                    config = Marshal.load(f)
                end

                p config
                @output_file_name.value = config.output_file_name
                @data_dir.value = check_directory(config.data_dir)

            rescue
                p "Failed to load configuration."
            end
        else
            p "No configuration file to load..."
        end
    end
end