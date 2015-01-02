require 'debugger'
require 'yaml'
require 'mixpanel_client'
require 'pp'
require 'csv'
require '/home/emingo/job/zip_it_up/automator'
require '/home/emingo/job/zip_it_up/dataparser'

class WeeklyReport
  def initialize(account_id, newsrooms, from_date, to_date)
    @client = Mixpanel::Client.new(
      api_key: "bf0830dac108946d23b13ad2aa4fb117",
      api_secret:  "dbdba192a6a50bd5abf721f2af7da23b"
    )
    @account_id = account_id
    @from_date = from_date
    @to_date = to_date
    @pub_events = YAML.load_file('buckets.yaml')
    @use_events = YAML.load_file('diversity.yaml')
    @data = @client.request('export', 
                          from_date: @from_date,
                          to_date: @to_date,
                          where: "properties[\"_account_id\"] == \"#{@account_id}\""
                         )

    @newsrooms = newsrooms

    @parser = DataParser.new(get_all_events)


    @diversity_count_array = { "Drupal"=> 0, 
                   "Wordpress"=> 0, 
                   "Expression Engine"=> 0, 
                   "Other XML-RPC"=> 0, 
                   "Tumblr"=> 0, 
                   "Hubspot"=> 0, 
                   "Adobe CQ"=> 0,
                   "Blogger"=> 0, 
                   "Slideshare"=> 0, 
                   "Box"=> 0, 
                   "UberFlip"=> 0, 
                   "KapostCloud"=> 0, 
                   "Jive"=> 0, 
                   "Lithium"=> 0, 
                   "Brightcove"=> 0,
                   "YouTube"=> 0, 
                   "Vidyard"=> 0, 
                   "Soundcloud"=> 0, 
                   "webinar"=> 0, 
                   "Library: Shared via Email"=> 0, 
                   "Library: Shared via Social"=> 0,
                   "Salesforce"=> 0, 
                   "Integration- Added Marketo Asset"=> 0, 
                   "Integration- Created Marketo Asset"=> 0,
                   "Integration- Added Eloqua Asset"=> 0, 
                   "Integration- Created Eloqua Asset"=> 0,
                   "Integration- Added Pardot Asset"=> 0, 
                   "Integration- Created Pardot Asset" => 0
                  } 
    @published_count_array = { "Drupal"=> 0, 
                   "Wordpress"=> 0, 
                   "Expression Engine"=> 0, 
                   "Other XML-RPC"=> 0, 
                   "Tumblr"=> 0, 
                   "Hubspot"=> 0, 
                   "Adobe CQ"=> 0,
                   "Blogger"=> 0, 
                   "Slideshare"=> 0, 
                   "Box"=> 0, 
                   "UberFlip"=> 0, 
                   "KapostCloud"=> 0, 
                   "Jive"=> 0, 
                   "Lithium"=> 0, 
                   "Brightcove"=> 0,
                   "YouTube"=> 0, 
                   "Vidyard"=> 0, 
                   "Soundcloud"=> 0, 
                   "webinar"=> 0, 
                   "Library: Shared via Email"=> 0, 
                   "Library: Shared via Social"=> 0,
                   "Salesforce"=> 0, 
                   "Integration- Added Marketo Asset"=> 0, 
                   "Integration- Created Marketo Asset"=> 0,
                   "Integration- Added Eloqua Asset"=> 0, 
                   "Integration- Created Eloqua Asset"=> 0,
                   "Integration- Added Pardot Asset"=> 0, 
                   "Integration- Created Pardot Asset" => 0
                  } 
  end

  def return_data
    @data
  end

  def return_pub_count_array
    @published_count_array
  end

  def return_diversity_count_array
    @diversity_count_array
  end

  
  def group_newsrooms(mapping)
    account_ids = {}
    mapping.each do |key, value|
      key.each do |newsroom, account_id|
        if not account_ids.include? account_id
          account_ids.merge!(account_id => [])
        end
      end
    end
    account_ids.keys.each do |account_id|
      mapping.each do |key, value|
        key.each do |newsroom, id|
          if account_id == id
            account_ids[account_id].push(newsroom)
          end
        end
      end
    end
    account_ids
  end

  def get_total_users()
    huh = '1yUSR2zmAqva6sNPrdur'
    user_container = Array.new
    @newsrooms.each do |newsroom|
      k = KapostAutomator.new("https://#{newsroom}.kapost.com", huh)
      users = k.return_member_count
      users.each do |user|
        if not user_container.include?(user)
          user_container.push(user)
        end
      end
    end
    user_container
  end

  def get_active_users()
    users = Array.new
    @data.each do |event|
      if not users.include?(event['properties']['distinct_id'])
        users.push(event['properties']['distinct_id'])
      end
    end
    users
  end

  def get_all_events()
    event_array = Array.new
    @data.each do |event|
      event_array.push({'event' => event['event'], 'platform' => event['properties']['platform'], 'body_type' => event['properties']['body_type'], 'ts' => event['properties']['time'], 'primary_destination' => event['properties']['Primary Destination']})
    end
    event_array
  end

#  def get_events_comp_pub()
#    event_array = Array.new
#    @data.each do |event|
#      if event['properties']['platform'] != nil or event['properties']['body_type'] != nil
#        event_array.push({'event' => event['event'], 'platform' => event['properties']['platform'], 'body_type' => event['properties']['body_type'], 'ts' => event['properties']['time']})
#      end
#    end
#    event_array
#  end

  def count_pub()
    bucket_count = {"Blog Post Publishing" => 0,
                    "Document Publishing" => 0, 
                    "Community Publishing" => 0,
                    "Video Publishing" => 0, 
                    "Audio Publishing" => 0,
                    "Webinar Management" => 0,
                    "Marketing Automation" => 0
                   }

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

      get_all_events().each do |event|
      name = event['event']
      platform = event['platform']
      body_type = event['body_type']
      bucket_count.keys.each do |use_case|
        @pub_events[use_case].keys.each do |event|
          if keyless.include? event
            if name == event
              bucket_count[use_case] += 1
              pub_drilldown(platform)
              pub_drilldown(body_type)
              pub_drilldown(name)
            end
          else
          @pub_events[use_case][event].keys.each do |action|
            if @pub_events[use_case][event][action].include? platform or @pub_events[use_case][event][action].include? body_type
              pub_drilldown(platform)
              pub_drilldown(body_type)
              pub_drilldown(name)
              bucket_count[use_case] += 1
            end
            end
          end
        end
      end
    end
    bucket_count
  end

  #def diversity_count()
#    bucket_count = {"Blog Post Publishing" => false,
#                    "Document Publishing" => false, 
#                    "Community Publishing" => false,
#                    "Video Publishing" => false, 
#                    "Audio Publishing" => false, 
#                    "Webinar Management" => false,
#                    "Marketing Automation" => false,
#                    "Marketing & Sales Enablement" => false,
#                    "Event Management" => false
#                   }
#    keyless = ["Editing Library Notes",
#               "Library Content Shared",
#               "Post- readytalk webinar set", 
#              "Library: Shared via Social",
#              "Library: Shared via Email", 
#              "Editing Library Notes",
#              "Integration- Added Marketo Asset",
#              "Integration- Created Marketo Asset",
#              "Integration- Added Eloqua Asset",
#              "Integration- Created Eloqua Asset",
#              "Integration- Added Pardot Asset",
#              "Integration- Created Pardot Asset"]
#
#      get_all_events.each do |event|
#      name = event['event']
#      platform = event['platform']
#      body_type = event['body_type']
#      bucket_count.keys.each do |use_case|
#        @use_events[use_case].keys.each do |event|
#          if keyless.include? event 
#            if name == event
#              bucket_count[use_case] = true
#              diversity_drilldown(platform)
#              diversity_drilldown(name)
#              diversity_drilldown(body_type)
#            end
#          else 
#          @use_events[use_case][event].keys.each do |action|
#            if @use_events[use_case][event][action].include? platform or @use_events[use_case][event][action].include? body_type
#              bucket_count[use_case] = true
#              diversity_drilldown(platform)
#              diversity_drilldown(body_type)
#            end
#          end
#        end
#      end
#    end
#    end
#    bucket_count
#  end

  def diversity_count
    @parser.diversity_count
    @parser.return_truth
  end

  def diversity_boolean
    @parser.diversity_count
    @parser.return_truth_boolean
  end

  def pub_drilldown(property)
    if @published_count_array.keys.include? property
      @published_count_array[property] = @published_count_array[property] + 1
    end
  end

  def diversity_drilldown(property)
    if @diversity_count_array.keys.include? property
      @diversity_count_array[property] = @diversity_count_array[property] + 1
    end
  end


  def all_data_array
    array_to_write = Array.new
    array_to_write.push(@account_id)
    array_to_write.push(get_active_users.count)
    array_to_write.push(get_total_users.count)

    diversity_boolean().values.each do |boolean|
      array_to_write.push(boolean)
    end

    container = diversity_count
    container.keys.each do |use_case|
      container[use_case].each do |what_is|
        what_is.values.each do |count|
          array_to_write.push(count)
        end
      end
    end

    count_pub().values.each do |div_count|
      array_to_write.push(div_count)
    end

    return_pub_count_array.values.each do |pub_count|
      array_to_write.push(pub_count) 
    end
    array_to_write
  end

  def header_array()
    array_to_write = Array.new
    array_to_write.push('Account ID')
    array_to_write.push('Active Users')
    array_to_write.push('Total Users')

    diversity_count().keys.each do |boolean|
      array_to_write.push(boolean)
    end

    return_diversity_count_array().keys.each do |drilldown_count|
      array_to_write.push("#{drilldown_count} Diversity")

    end

    count_pub().keys.each do |div_count|
      array_to_write.push(div_count)
    end

    return_pub_count_array.keys.each do |pub_count|
      array_to_write.push("#{pub_count} Published") 
    end
    array_to_write
  end
end
