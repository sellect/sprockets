require 'sprockets/digest_utils'
require 'sprockets/path_utils'
require 'sprockets/cached_digest_utils'

module Sprockets
  # Internal: Crossover of path and digest utilities functions.
  module PathDigestUtils
    include DigestUtils, PathUtils
    include CachedDigestUtils

    # Internal: Compute digest for file stat.
    #
    # path - String filename
    # stat - File::Stat
    #
    # Returns String digest bytes.
    def stat_digest(path, stat)
      if stat.directory?
        # If its a directive, digest the list of filenames
        cached_version_digest.digest(self.entries(path).join(','))
      elsif stat.file?
        # If its a file, digest the contents
        cached_version_digest.file(path.to_s).digest
      else
        raise TypeError, "stat was not a directory or file: #{stat.ftype}"
      end
    end

    # Internal: Compute digest for path.
    #
    # path - String filename or directory path.
    #
    # Returns String digest bytes or nil.
    def file_digest(path)
      if stat = self.stat(path)
        self.stat_digest(path, stat)
      end
    end

    # Internal: Compute digest for a set of paths.
    #
    # paths - Array of filename or directory paths.
    #
    # Returns String digest bytes.
    def files_digest(paths)
      self.digest(paths.map { |path| self.file_digest(path) })
    end
  end
end
