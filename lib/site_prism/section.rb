module SitePrism
  class Section
    include Capybara::DSL
    include ElementChecker
    extend ElementContainer

    attr_reader :root_element, :parent

    def initialize parent, root_element 
      @parent, @root_element = parent, root_element
    end

    def visible?
      root_element.visible?
    end

    def execute_script input
      Capybara.current_session.execute_script input
    end

    def evaluate_script input
      Capybara.current_session.evaluate_script input
    end

    def parent_page
      candidate_page = self.parent
      until candidate_page.is_a?(SitePrism::Page)
        candidate_page = candidate_page.parent
      end
      candidate_page
    end

    private

    def find_first *find_args
      # Maintaining backwards compatibility
      if !Capybara.methods.include?(:match)
        begin
          root_element.find *find_args
        rescue Capybara::Ambiguous
          root_element.first *find_args
        end
      else
        root_element.find *find_args
      end
    end

    def find_all *find_args
      root_element.all *find_args
    end

    def element_exists? *find_args
      unless root_element.nil?
        root_element.has_selector? *find_args
      end
    end
  end
end

