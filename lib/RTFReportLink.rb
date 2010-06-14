#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = RTFReportLink.rb -- The TaskJuggler III Project Management Software
#
# Copyright (c) 2006, 2007, 2008, 2009, 2010 by Chris Schlaeger <cs@kde.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'RichTextFunctionHandler'
require 'XMLElement'
require 'URLParameter'

class TaskJuggler

  # This class is a specialized RichTextFunctionHandler that generates a link
  # to another report. It's not available on all output formats.
  class RTFReportLink < RichTextFunctionHandler

    def initialize(project, sourceFileInfo = nil)
      super(project, 'reportlink', sourceFileInfo)
      @blockFunction = false
    end

    # Not supported for this function
    def to_s(args)
      ''
    end

    # Return a HTML tree for the report.
    def to_html(args)
      if args.nil? || (id = args['id']).nil?
        error('rtp_report_id',
              "Argument 'id' missing to specify the report to be used.")
        return nil
      end
      unless (report = @project.report(id))
        error('rtp_report_unknown_id', "Unknown report #{id}")
        return nil
      end

      # The URL for interactive reports is different than for static reports.
      if report.interactive?
        # The project and report ID must be provided as query.
        url = "taskjuggler?project=#{@project['projectid']};" +
              "report=#{report.fullId}"

        if args['attributes']
          url += ";attributes=" + URLParameter.encode(args['attributes'])
        end
      else
        # The report name just gets a '.html' extension.
        url = report.name + ".html"
      end
      a = XMLElement.new('a', 'href'=> url)
      a << XMLText.new(report.name)
      a
    end

    # Not supported for this function.
    def to_tagged(args)
      nil
    end

  end

end


