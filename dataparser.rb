require 'yaml'
require 'pp'


class DataParser
  def initialize(array_of_events)
    @array_of_events = array_of_events
    @truth_boolean = diversity_boolean_hash
    @truth = diversity_bucket_builder
  end


  def diversity_bucket_builder()

      keyless = [
                "Editing Library Notes",
                "Library Content Shared", 
                "Post- readytalk webinar set", 
                "Library: Shared via Social", 
                "Library: Shared via Email", 
                "Editing Library Notes",
                "Integration- Added Marketo Asset",
                "Integration- Created Marketo Asset",
                "Integration- Added Eloqua Asset",
                "Integration- Created Eloqua Asset",
                "Integration- Added Pardot Asset",
                "Integration- Created Pardot Asset"]

    diversity_hash = YAML.load_file('diversity.yaml')
    diversity_hash_buckets = Hash.new

    diversity_hash.keys.each do |use_case|
      diversity_hash_buckets.merge!(use_case => [])
      diversity_hash[use_case].each do |action|
        if keyless.include? action[0]
            diversity_hash_buckets[use_case].push(action[0] => 0)
        else
          #puts "use case: #{use_case} action: #{action}"
          diversity_hash[use_case][action[0]].keys.each do |property_types|
          diversity_hash[use_case][action[0]][property_types].each do |property|
            identity = "#{action[0]} #{property}"
            diversity_hash_buckets[use_case].push(identity => 0)
          end
        end
      end
      end
    end
    diversity_hash_buckets
  end


  def diversity_boolean_hash
    diversity_hash = YAML.load_file('diversity.yaml')
    container = Hash.new
    diversity_hash.keys.each do |use_case|
      container.merge!(use_case => false)
    end
    container
  end

  def diversity_count()
#    pp @array_of_events
  keyless = [
  "Integration- Added Marketo Asset",
  "Integration- Created Marketo Asset",
  "Integration- Added Eloqua Asset",
  "Integration- Created Eloqua Asset",
  "Integration- Added Pardot Asset",
  "Integration- Created Pardot Asset",
  "Library: Shared via Email",
  "Library: Shared via Social"]

    @array_of_events.each do |event|
      name = event['event']
      platform = event['platform']
      body_type = event['body_type']
      primary_destination = event['primary_destination']
      if name == "Comment: added, belongs to: Post" or name == "Content Task Complete"
        test_identity = "#{name} #{primary_destination}"
      elsif name == "Post- Publish"
        test_identity = "#{name} #{platform}"
      elsif keyless.include? name
	test_identity = "#{name}"
      end
      @truth.keys.each do |use_case|

        @truth[use_case].each do |what|
      if what[test_identity]
        what[test_identity] = what[test_identity] + 1
        @truth_boolean[use_case] = true
      end
    end
  end
    end
  end

 def return_truth
   @truth
 end 
 
 def return_truth_boolean
   @truth_boolean
 end 


#end of class
end

#account = WeeklyReport.new('LivePerson', ['stupid', 'design'], '2014-10-30', '2014-10-31')
#data_to_pass = account.get_all_events
###pp account.return_data
##
#parser = DataParser.new(data_to_pass)
###pp parser.diversity_bucket_builder
###pp parser.diversity_count
##
##
#parser.diversity_count
#
#pp parser.return_truth
#pp parser.return_truth_boolean
