module Paperclip
  
  class Circular < Processor
  
    attr_accessor :current_geometry, :target_geometry, :format, :whiny, :convert_options, :source_file_options, :auto_orient
 
    def initialize(file, options = {}, attachment = nil)
      super

      geometry             = options[:geometry].to_s
      @file                = file
      @crop                = geometry[-1,1] == '#'
      @target_geometry     = options.fetch(:string_geometry_parser, Geometry).parse(geometry)
      @current_geometry    = options.fetch(:file_geometry_parser, Geometry).from_file(@file)
      @source_file_options = options[:source_file_options]
      @convert_options     = options[:convert_options]
      @whiny               = options.fetch(:whiny, true)
      @format              = options[:format]
      @auto_orient         = options.fetch(:auto_orient, true)

      if @auto_orient && @current_geometry.respond_to?(:auto_orient)
        @current_geometry.auto_orient
      end

      @source_file_options = @source_file_options.split(/\s+/) if @source_file_options.respond_to?(:split)
      @convert_options     = @convert_options.split(/\s+/)     if @convert_options.respond_to?(:split)

      @current_format      = File.extname(@file.path)
      @basename            = File.basename(@file.path, @current_format)
    end

    def make
      puts 'helloooooo'
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      dst.binmode
      parameters = []
      parameters << " #{Rails.root}/public/avatar-back.png -gravity center \\( -resize 180x180 \\( "
      parameters << File.expand_path(@file.path)
      parameters << "\\) \\) #{Rails.root}/public/avatar-mask.gif -compose dstover -composite "
      parameters << "-resize #{@target_geometry.width}x#{@target_geometry.height}"
      parameters << File.expand_path(dst.path)

      begin
        Paperclip.run('convert', parameters.join(' '))
        Paperclip.run('convert', parameters.join(' '))
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "There was an error processing the thumbnail for #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run the `convert` command. Please install ImageMagick.")
      end
      
      dst
    end

  end

end
