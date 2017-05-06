module Imgurapi
  module Api
    class Image < Base

      # https://api.imgur.com/endpoints/image#image
      def image(id)
        raise 'Please provide a valid image identificator' if id.nil? or !id.kind_of? String or id == '' or !!(id =~ /[^\w]/)

        Imgurapi::Image.new communication.call(:get, "image/#{id}")
      end

      # https://api.imgur.com/endpoints/image#image-upload
      def image_upload(local_file_or_url)
        if local_file_or_url.kind_of? String
          if local_file_or_url.downcase.start_with?('http://', 'https://', 'ftp://')
            return Imgurapi::Image.new communication.call(:post, 'image', image: local_file_or_url)
          end

          file = File.open(local_file_or_url, 'rb')
        elsif local_file_or_url.respond_to? :read
          file = local_file_or_url
        else
          raise 'Must provide a File or file path'
        end

        Imgurapi::Image.new communication.call(:post, 'image', image: Base64.encode64(file.read))
      end

      # https://api.imgur.com/endpoints/image#image-delete
      def image_delete(id)
        if id.kind_of? Imgurapi::Image
          id = id.id
        end

        raise 'Please provide a valid image identificator' if id.nil? or !id.kind_of? String or id == '' or !!(id =~ /[^\w]/)

        communication.call(:delete, "image/#{id}")
      end
    end
  end
end
