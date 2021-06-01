# frozen_string_literal: true

module Ticker
  def self.root_path(*path_components)
    File.join(File.dirname(File.dirname(__dir__)), *path_components)
  end
end
