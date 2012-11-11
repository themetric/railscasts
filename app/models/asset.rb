require 'open-uri' 

class Asset < ActiveRecord::Base
    belongs_to :assetable, :polymorphic => true
    #acts_as_list :scope => :assetable

    # Use > to only shrink images larger than size given 
    # Use the # to crop fit when shrinking
    has_attached_file :attachment, 
    	:styles => { normal: "750x750>", thumb: '100x100#', mini_thumb: "45x45#"},
    :url => ":id/:style_:basename.:extension",
    :path => ":id/:style_:basename.:extension",
    :storage => :s3,
    :s3_credentials => { :access_key_id     => APP_CONFIG['s3_key'],
                         :secret_access_key => APP_CONFIG['s3_secret'] },
    :bucket => "ms_#{Rails.env}_assets" 

    validates_attachment_size :attachment, :less_than => 4.megabytes
    validates_attachment_content_type :attachment, :content_type => /image/   
    
    def attachment_from_url(url) 
        io = open(URI.parse(url))
        # Maintain the original file's extension 
        def io.original_filename
            base_uri.path.split('/').last
        end
        io.original_filename.blank? ? nil : io
        # Assign the io to the paperclip attachment 
        self.attachment = io         
    end  
        
end
