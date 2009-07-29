module Bundler
  def self.rubygems_required
    <% spec_files.each do |name, path| %>
    Gem.loaded_specs["<%= name %>"] = eval(File.read("<%= path %>"))
    Gem.source_index.add_spec(Gem.loaded_specs["<%= name %>"])
    <% end %>
  end
end

<% unless @system_gems %>
ENV["GEM_HOME"] = "<%= @repository.path %>"
ENV["GEM_PATH"] = "<%= @repository.path %>"
<% end %>
ENV["PATH"]     = "<%= @bindir %>:#{ENV["PATH"]}"
ENV["RUBYOPT"]  = "-r#{__FILE__} #{ENV["RUBYOPT"]}"

<% if @rubygems == :optional %>
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
<% end %>
<% load_paths.each do |load_path| %>
$LOAD_PATH.unshift "<%= load_path %>"
<% end %>
<% if @rubygems == :require %>
require "rubygems"
Bundler.rubygems_required
<% elsif @rubygems == :disable %>
$" << "rubygems.rb"
module Kernel
  def gem(*)
    # Silently ignore calls to gem, since, in theory, everything
    # is activated correctly already.
  end
end

# Define all the Gem errors for gems that reference them.
module Gem
  def self.ruby ; <%= Gem.ruby.inspect %> ; end
  class LoadError < ::LoadError; end
  class Exception < RuntimeError; end
  class CommandLineError < Exception; end
  class DependencyError < Exception; end
  class DependencyRemovalException < Exception; end
  class GemNotInHomeException < Exception ; end
  class DocumentError < Exception; end
  class EndOfYAMLException < Exception; end
  class FilePermissionError < Exception; end
  class FormatException < Exception; end
  class GemNotFoundException < Exception; end
  class InstallError < Exception; end
  class InvalidSpecificationException < Exception; end
  class OperationNotSupportedError < Exception; end
  class RemoteError < Exception; end
  class RemoteInstallationCancelled < Exception; end
  class RemoteInstallationSkipped < Exception; end
  class RemoteSourceException < Exception; end
  class VerificationError < Exception; end
  class SystemExitException < SystemExit; end
end
<% end %>