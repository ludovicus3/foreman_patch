module ForemanPatch
  class CycleContent
    class Content
      attr_accessor :cycle_content
      attr_reader :content_view, :major, :environments
      delegate :composite?, to: :content_view

      def initialize(version)
        @content_view = version.content_view
        @major = version.major

        @environments = []
      end

      def version
        content_view.versions.where(major: major).order(minor: :desc).first
      end

      def ==(other)
        other.is_a?(Content) and content_view.id == other.content_view.id and major == other.major
      end
      alias eql? ==

      def hash
        [content_view.id, major].hash
      end

      def update?
        @update = check_content if @update.nil?
        @update
      end

      def components
        version.components.map do |component|
          cycle_content[component].version
        end
      end

      private

      def check_content
        if content_view.composite?
          version.components.any? do |component|
            cycle_content[component].update?
          end
        else
          version.available_packages.any? or version.available_errata.any? or Katello::Deb.in_repositories(version.library_repos).where.not(id: version.debs).any?
        end
      end
    end

    def initialize(cycle)
      @hash = {}

      cycle.hosts.map do |host|
        host.content_view.version(host.lifecycle_environment)
      end.uniq.each do |version|
        add(version)
      end
    end

    def [](key)
      key = Content.new(key) if key.is_a? Katello::ContentViewVersion

      @hash[key]
    end

    def each(&block)
      @hash.each_value(&block)
    end

    def select(&block)
      @hash.values.select(&block)
    end

    private

    def add(version)
      return unless version.is_a? Katello::ContentViewVersion

      content = @hash.fetch(Content.new(version)) do |key|
        key.cycle_content = self
        @hash.store(key, key)
      end
      content.environments.concat(version.environments).uniq!

      version.components.each do |component|
        add(component)
      end
    end
  end
end
