require 'open-uri'
require 'debugger'

def parse_ucb

  @doc = Nokogiri::XML(open("http://losangeles.ucbtrainingcenter.com/courses/open/rss"))
  @open_classes = @doc.xpath("//item")

  @open_classes.each do |open_class| #@open_classes[0].xpath('.//title').children[0].content

    params = xml_to_attributes(open_class)
    course = Course.new(params)
    debugger
  end
end


def xml_to_attributes(open_class)
  unparsed_class_and_slots = open_class.xpath('.//title').children[0].content
  unparsed_times_and_instructor = open_class.xpath('.//description').children[0].content
  unparsed_start_date = open_class.xpath('.//pubDate').children[0].content
  reg_link = open_class.xpath('.//guid').children[0].content

  {:link => reg_link}
  .merge(parse_start_date(unparsed_start_date))
  .merge(parse_class_and_slots(unparsed_class_and_slots))
  .merge(parse_times_instructor(unparsed_times_and_instructor))
end

def parse_times_instructor(unparsed)
  pattern = /(.*) with( (.*))?/
  matches = pattern.match(unparsed)
  {:course_schedule => matches[1]} #LOOKA T LATER
  {:teacher => (matches[3] || "Intensive")}
end

def parse_start_date(unparsed)
  pattern = /(.*) \d+:/
  match = pattern.match(unparsed)
  {:start_date => match[1]}
end


def parse_class_and_slots(unparsed)
  pattern = /(\d+) (.*)\((\d+)/
  matches = pattern.match(unparsed.gsub(/\t|\n|\)|:/, ""))
  {:online_id => matches[1], :name => matches[2], :avail_slots => matches[3]}
end

#This one giving problems:
# <item>
# <title>9551: Improv 101</title>
# <link>
# http://losangeles.ucbtrainingcenter.com/courses/view/9551
# </link>
# <guid>
# http://losangeles.ucbtrainingcenter.com/courses/view/9551
# </guid>
# <pubDate>Fri, 14 Feb 2014 20:00:00 GMT</pubDate>
# <description>Fridays noon-3pm with Drew DiFonzo Marks</description>
# </item>