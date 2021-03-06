require 'mixpanel_client'
require 'pp'
require 'csv'
require '/home/emingo/job/zip_it_up/mixpanel'

accounts = [
 ["visage"=> "Original 9"],
 ["tab-bank"=> "LeadMD"],
 ["blue-shield-ca"=> "LeadMD"],
 ["smartvan"=> "Original 9"],
 ["careinnovations"=> "LeadMD"],
 ["genprog"=> "Generation Progress"],
 ["imfcon"=> "iHTT"],
 ["momtastic"=> "Evolve Media"],
 ["hid"=> "LeadMD"],
 ["convercent"=> "Original 9"],
 ["sbcedia"=> "Smallbox"],
 ["pedowitzgroup"=> "Pedowitz Group"],
 ["mingo"=> "Kapost Cloud"],
 ["renesaskorea"=> "Renesas"],
 ["renesasjapan"=> "Renesas"],
 ["globeu"=> "Globe University"],
 ["acronis"=> "Original9"],
 ["intel-apac"=> "Intel"],
 ["intel-lar"=> "Intel"],
 ["intel-emea"=> "Intel"],
 ["tcrsfdc"=> "Salesforce.com"],
 ["freepint"=> "FreePint"],
 ["amway"=> "Amway"],
 ["proteomics"=> "Thermo Fisher Scientific"],
 ["smallbox"=> "SmallBox"],
 ["aerotek"=> "Aerotek"],
 ["renesastaiwan"=> "Renesas"],
 ["efma"=> "EFMA"],
 ["intel-dev"=> "Intel"],
 ["siue"=> "SIUe (Southern Illinois University Edwardsville)"],
 ["tablespoon"=> "General Mills"],
 ["livepersondev"=> "LivePerson"],
 ["medtronicoldinactive"=> "LeadMD"],
 ["red-lion-controls"=> "LeadMD"],
 ["appfolio"=> "LeadMD"],
 ["renesaschina"=> "Renesas"],
 ["waterrf"=> "Water Research Foundation"],
 ["discoverynews"=> "Discovery News"],
 ["renesassingapore"=> "Renesas"],
 ["5minutesformom"=> "5 Minutes For Mom"],
 ["vidyard"=> "Vidyard"],
 ["plex"=> "Plex Systems"],
 ["cornerstone-ondemand"=> "Original 9"],
 ["brightedge"=> "LeadMD"],
 ["sbmodular"=> "Smallbox"],
 ["searchkings"=> "Search Kings"],
 ["globaledu"=> "John Wiley & Sons Publishing"],
 ["demovisitscotland"=> "VisitScotland"],
 ["sbpuccinis"=> "Smallbox"],
 ["searchkingsdemo"=> "Search Kings"],
 ["healthypaws"=> "Original9"],
 ["thebestpracticedemo"=> "theperfectinstance"],
 ["responsys"=> "Original 9"],
 ["cad"=> "Thermo Fisher Scientific "],
 ["hsg"=> "LeadMD"],
 ["contentmarketinginstitute"=> "Content Marketing Institute "],
 ["hoverround"=> "Response Mine Interactive"],
 ["northamericanspine1"=> "Response Mine Interactive"],
 ["northamericanspine4"=> "Response Mine Interactive"],
 ["marinerslearningsystem"=> "LeadMD"],
 ["ringlead"=> "LeadMD"],
 ["renesasapac"=> "Renesas"],
 ["adviserinvestments"=> "LeadMD"],
 ["original9"=> "Original 9"],
 ["modtown"=> "Speakeasy"],
 ["iagbestpractice"=> "International Business Machines Corporation (IBM)"],
 ["partnerdemo"=> "theperfectinstance"],
 ["deltak"=> "John Wiley & Sons Publishing"],
 ["modernhonolulu"=> "Miles Partnership - Modern Honolulu"],
 ["delldev"=> "theperfectinstance"],
 ["galleriadallas"=> "Speakeasy"],
 ["teletech"=> "Original9"],
 ["ascendant-pain-and-spine"=> "Speakeasy"],
 ["davidandgoodman"=> "Speakeasy"],
 ["hacheu"=> "Hach Company"],
 ["luminafoundation"=> "Lumina Foundation"],
 ["fuzzystacos"=> "Speakeasy"],
 ["sfdccorpmarketing"=> "salesforce.com"],
 ["auditortest"=> "Kapost Cloud"],
 ["bma"=> "Not in SFDC"],
 ["sirsidynix"=> "SirsiDynix"],
 ["zuberance"=> "LeadMD"],
 ["intel"=> "Intel"],
 ["leadmd"=> "LeadMD"],
 ["fairchild-semiconductor"=> "LeadMD"],
 ["pitneybowes"=> "Pitney Bowes Software"],
 ["renesaseurope"=> "Renesas"],
 ["leicageosystems"=> "Leica Geosystems"],
 ["k2software"=> "K2"],
 ["pace"=> "Pace Communications"],
 ["mashable"=> "Mashable"],
 ["demandgen"=> "DemandGen USA"],
 ["jci"=> "Johnson Controls "],
 ["park-place"=> "Speakeasy"],
 ["vocus-prweb"=> "TopRank Marketing"],
 ["condenast"=> "Original9"],
 ["schooldudes"=> "LeadMD"],
 ["turn"=> "Turn Inc"],
 ["obliterase"=> "LeadMD"],
 ["sbacsm"=> "Smallbox"],
 ["cma"=> "CMA"],
 ["datasift"=> "DataSift Inc."],
 ["turnstone"=> "Turnstone"],
 ["searchkingstemplate"=> "Search Kings"],
 ["sbmcl"=> "SmallBox"],
 ["everydayhealth"=> "Everyday Health Inc"],
 ["coupa-software"=> "LeadMD"],
 ["operativemedia"=> "Operative Media, Inc."],
 ["ccn"=> "Chamberlain College of Nursing"],
 ["stoutsocial"=> "Stout Social"],
 ["ricoh-usa"=> "LeadMD"],
 ["etc2"=> "Speakeasy"],
 ["navyfederalcreditunion"=> "Response Mine Interactive"],
 ["northamericanspine3"=> "Response Mine Interactive"],
 ["thefashionspot"=> "Fashion Spot"],
 ["ruxit"=> "Original 9"],
 ["fidelitynationaltrust"=> "Speakeasy"],
 ["medtronicdemo"=> "theperfectinstance"],
 ["brightreedemo"=> "theperfectinstance"],
 ["hsuite"=> "HootSuite"],
 ["achmea"=> "Search Kings"],
 ["medigain"=> "Speakeasy"],
 ["tentoo"=> "Search Kings"],
 ["theperfectinstance"=> "theperfectinstance"],
 ["salesforcetmb"=> "Salesforce.com"],
 ["demandbase"=> "DemandBase"],
 ["zurichna"=> "Zurich North America Insurance"],
 ["iag-bda"=> "International Business Machines Corporation (IBM)"],
 ["blackboard"=> "Blackboard"],
 ["greenvillechrysler"=> "Speakeasy"],
 ["biobanking"=> "Thermo Fisher Scientific"],
 ["rsi"=> "RSi"],
 ["jared3"=> "Jared 3 Testing"],
 ["demandware"=> "Demandware Inc"],
 ["csc"=> "CSC"],
 ["degreeprospects"=> "Degree Prospects"],
 ["creativesafetysupply"=> "Creative Safety Supply"],
 ["lexisnexis"=> "LexisNexis"],
 ["teamexos"=> "Athletes' Performance, Inc. / Team Exos"],
 ["shoretel"=> "ShoreTel"],
 ["brady"=> "Brady Corporation"],
 ["lenovo"=> "Lenovo"],
 ["pivotdesk"=> "Pivot Desk"],
 ["renesasamericas"=> "Renesas"],
 ["mashery"=> "Mashery"],
 ["accellion"=> "Accellion"],
 ["wileytemplate"=> "John Wiley & Sons Publishing"],
 ["intelb2bsocialteam"=> "Intel CMG - B2B ITDM"],
 ["wdesk"=> "Workiva"],
 ["revolutiondancewear"=> "Revolution Dancewear"],
 ["cbslocal"=> "CBS Local"],
 ["twc"=> "Examiner"],
 ["believe"=> "Examiner"],
 ["paperstyle"=> "Response Mine Interactive"],
 ["northamericanspine2"=> "Response Mine Interactive"],
 ["fisherbioservices"=> "Thermo Fisher Scientific"],
 ["wileydemo"=> "John Wiley & Sons Publishing"],
 ["medtronic"=> "LeadMD"],
 ["csc-dev"=> "CSC"],
 ["vantuylcrestautogroup"=> "Speakeasy"],
 ["vanguardvodka"=> "Speakeasy"],
 ["leadmd1"=> "LeadMD"],
 ["templatespeakeasy"=> "Speakeasy"],
 ["speakeasy"=> "Speakeasy"],
 ["aib"=> "Australian Institute of Business"],
 ["surgical-institute-for-sleep"=> "Speakeasy"],
 ["americanhomeshield"=> "Speakeasy"],
 ["visitscotland"=> "VisitScotland"],
 ["pbi"=> "John Wiley & Sons Publishing"],
 ["concuremeaapa"=> "Concur"],
 ["rocket-software-platform"=> "LeadMD"],
 ["sita"=> "LeadMD"],
 ["autodesk"=> "Autodesk Inc"],
 ["swifttransportation"=> "LeadMD"],
 ["etc"=> "Speakeasy"],
 ["mesquiteschools"=> "Speakeasy"],
 ["frusiongowild"=> "Speakeasy"],
 ["dell"=> "Dell"],
 ["attdev"=> "theperfectinstance"],
 ["flipkey"=> "Flipkey"],
 ["integra"=> "Integra"],
 ["revinate"=> "Revinate"],
 ["kapostmarketing"=> "Kapost Marketing"],
 ["recommind"=> "Recommind, Inc."],
 ["needle"=> "Needle"],
 ["evault"=> "Seagate Technology LLC"],
 ["blackbaud"=> "Blackbaud"],
 ["catalent"=> "Catalent Pharma Solutions"],
 ["extole"=> "LeadMD"],
 ["usgbc"=> "USGBC"],
 ["cbs"=> "Examiner"],
 ["intermedia"=> "Intermedia"],
 ["vimvigorjuice"=> "Speakeasy"],
 ["ithaca"=> "LeadMD"],
 ["agility"=> "LeadMD"],
 ["reachforce"=> "LeadMD"],
 ["creditguard"=> "Response Mine Interactive"],
 ["sfdctemplate"=> "Salesforce.com"],
 ["responsemine"=> "Response Mine Interactive"],
 ["slingshot"=> "Speakeasy"],
 ["newspeakeasy"=> "Speakeasy"],
 ["mamaspizza"=> "Speakeasy"],
 ["dmnmedia"=> "Speakeasy"],
 ["tacobueno"=> "Speakeasy"],
 ["plasticsurgerychannel"=> "Speakeasy"],
 ["ahs"=> "Speakeasy"],
 ["jackblack"=> "Speakeasy"],
 ["goldinpeiserandpeiser"=> "Speakeasy"],
 ["roundtreeauto"=> "Speakeasy"],
 ["dmncharities"=> "Speakeasy"],
 ["borden"=> "Speakeasy"],
 ["regus"=> "Speakeasy"],
 ["rise"=> "Speakeasy"],
 ["greatwesternfurniture"=> "Speakeasy"],
 ["dmnfdluxe"=> "Speakeasy"],
 ["newbellinvito"=> "Speakeasy"],
 ["newdmnnative"=> "Speakeasy"],
 ["drdirk"=> "Speakeasy"],
 ["epicsourcefoods"=> "Speakeasy"],
 ["newjackblack"=> "Speakeasy"],
 ["newkey-whitman"=> "Speakeasy"],
 ["newroundtree"=> "Speakeasy"],
 ["samplehouseandcandleshop"=> "Speakeasy"],
 ["tcu"=> "Speakeasy"],
 ["thedec"=> "Speakeasy"],
 ["trinitygroves"=> "Speakeasy"],
 ["weirsfurniture"=> "Speakeasy"],
 ["508digital"=> "Speakeasy"],
 ["nyuad"=> "NYU Abu Dhabi"],
 ["cscclone"=> "CSC"],
 ["csc2"=> "CSC"],
 ["dandbcc"=> "Dun and Bradstreet Credibility Corp."],
 ["riskedit"=> "LRP"],
 ["att"=> "AT&T"],
 ["templatewiley"=> "John Wiley & Sons Publishing"],
 ["medivo"=> "Medivo, Inc."],
 ["shredit"=> "Shred-it International Inc"],
 ["concursmb"=> "Concur"],
 ["peak10"=> "Peak10"],
 ["sports"=> "Examiner"],
 ["dealsplus"=> "Examiner"],
 ["northamericanspine"=> "Response Mine Interactive"],
 ["key-whitman"=> "Speakeasy"],
 ["accellionsneakpeek"=> "Accellion"],
 ["foodtesting"=> "Thermo Fisher Scientific"],
 ["trade-nte"=> "TRADE-NTE"],
 ["methodisthealthcaresystem"=> "Speakeasy"],
 ["bellinvito"=> "Speakeasy"],
 ["dmnnative"=> "Speakeasy"],
 ["texas811"=> "Speakeasy"],
 ["five9"=> "Five9"],
 ["mingosbox"=> "Kapost Cloud"],
 ["yellowpages"=> "Yellow Pages"],
 ["bestpracticeibm"=> "International Business Machines Corporation (IBM)"],
 ["written-sbx"=> "Kapost Cloud"],
 ["northcentralsurgicalcenter"=> "Speakeasy"],
 ["newnorthcentralsurgicalcenter"=> "Speakeasy"],
 ["qualys"=> "Qualys"],
 ["hachus"=> "Hach Company"],
 ["talentacquisition"=> "Thermo Fisher Scientific"],
 ["bizmarketing"=> "John Wiley & Sons Publishing"],
 ["netapp"=> "NetApp"],
 ["exacttarget"=> "ExactTarget"],
 ["ftse"=> "FTSE Americas"],
 ["bizmanagement"=> "John Wiley & Sons Publishing"],
 ["verticalresponse"=> "VerticalResponse"],
 ["consumertrack"=> "Consumertrack"],
 ["dummies"=> "John Wiley & Sons Publishing"],
 ["finance"=> "John Wiley & Sons Publishing"],
 ["mathandstats"=> "John Wiley & Sons Publishing"],
 ["behlth"=> "John Wiley & Sons Publishing"],
 ["sdl"=> "SDL Tridion, Inc."],
 ["socialsciencesandhumanities"=> "John Wiley & Sons Publishing"],
 ["ringcentral"=> "RingCentral.com"],
 ["chemistry"=> "John Wiley & Sons Publishing"],
 ["worldlanguages"=> "John Wiley & Sons Publishing"],
 ["physicsandgeoscience"=> "John Wiley & Sons Publishing"],
 ["blueshielddemo"=> "theperfectinstance"],
 ["informaticademo"=> "theperfectinstance"],
 ["subzero-wolfdemo"=> "theperfectinstance"],
 ["cross-discipline"=> "John Wiley & Sons Publishing"],
 ["wileycorporate"=> "John Wiley & Sons Publishing"],
 ["eecommtech"=> "John Wiley & Sons Publishing"],
 ["k12"=> "John Wiley & Sons Publishing"],
 ["acctg"=> "John Wiley & Sons Publishing"],
 ["medicalandhealthscience"=> "John Wiley & Sons Publishing"],
 ["lifesciences"=> "John Wiley & Sons Publishing"],
 ["vetmedicine"=> "John Wiley & Sons Publishing"],
 ["culinary"=> "John Wiley & Sons Publishing"],
 ["talentmanagement"=> "John Wiley & Sons Publishing"],
 ["allstate"=> "Allstate"],
 ["tripit"=> "Concur"],
 ["concurglobalmarketing"=> "Concur"],
 ["concurnorthamerica"=> "Concur"],
 ["tech"=> "John Wiley & Sons Publishing"],
 ["dwa"=> "DWA"],
 ["spectrumhealthsystem"=> "Spectrum Health System"],
 ["rpp"=> "LeadMD"],
 ["corporate"=> "Thermo Fisher Scientific"],
 ["biz"=> "John Wiley & Sons Publishing"],
 ["solidworks"=> "DS SolidWorks Corp."],
 ["bizeconomics"=> "John Wiley & Sons Publishing"],
 ["vmwaremarketing"=> "VMware"],
 ["expandidigital"=> "Creation Agency"],
 ["informatica"=> "LeadMD"],
 ["newchristus"=> "Speakeasy"],
 ["vimandvigor"=> "Speakeasy"],
 ["govdelivery"=> "GovDelivery"],
 ["liveworld"=> "LiveWorld, Inc."],
 ["foodscience"=> "John Wiley & Sons Publishing"],
 ["hae"=> "John Wiley & Sons Publishing"],
 ["methodisthealth"=> "Speakeasy"],
 ["christus"=> "Speakeasy"],
 ["newtexas811"=> "Speakeasy"],
 ["smu"=> "SMU"],
 ["scorebig"=> "ScoreBig"],
 ["bluewolf"=> "Bluewolf"],
 ["navexglobal"=> "NAVEX Global"],
 ["rrd"=> "R.R. Donnelley Financial Services"],
 ["newgreenvillechrysler"=> "Speakeasy"],
 ["commvaultsystems"=> "CommVault Systems, Inc."],
 ["allurehomefragrance"=> "Speakeasy"],
 ["anaplan"=> "Anaplan"],
 ["travelhost"=> "Speakeasy"],
 ["solidfire"=> "SolidFire"],
 ["ultra"=> "Kapost Cloud"],
 ["inteldcg"=> "Intel"],
 ["carillon"=> "Speakeasy"],
 ["lemonadeday"=> "Speakeasy"],
 ["rockwell"=> "Rockwell Automation"],
 ["diplomat"=> "Diplomat"],
 ["ema"=> "Eric Mower Associates (EMA)"],
 ["motherruckers"=> "Speakeasy"],
 ["aec"=> "John Wiley & Sons Publishing"],
 ["sgsb"=> "Stanford Graduate School of Business"],
 ["grlibrarians"=> "John Wiley & Sons Publishing"],
 ["jared"=> "Jared's Instance"],
 ["avnetdemo"=> "theperfectinstance"],
 ["payments-training-solutions"=> "LeadMD"],
 ["cds-global"=> "CDS Global, Inc."],
 ["liveperson"=> "LivePerson"],
 ["intuit"=> "Intuit"],
 ["visitcaliforniacommunications"=> "theperfectinstance"],
 ["textronaviation"=> "LeadMD"],
 ["dnb"=> "Dun & Bradstreet"],
 ["native"=> "Speakeasy"],
 ["artizone"=> "Speakeasy"],
 ["donaldpliner"=> "Speakeasy"],
 ["newgaryriggshome"=> "Speakeasy"],
 ["crestauto"=> "Speakeasy"],
 ["newamericanhomeshield"=> "Speakeasy"],
 ["newartizone"=> "Speakeasy"],
 ["dallasarboretum"=> "Speakeasy"],
 ["eisemanjewels"=> "Speakeasy"],
 ["garyriggshome"=> "Speakeasy"],
 ["jenh"=> "Speakeasy"],
 ["zipcar"=> "Zipcar"],
 ["ciscokinetic"=> "Cisco Europe (DemandGen)"],
 ["ibmswgscsglob"=> "International Business Machines Corporation (IBM)"],
 ["kidkraft"=> "Speakeasy"],
 ["visitcaliforniamarketing"=> "Visit California"],
 ["rewrite"=> "Original 9"],
 ["demandaplan"=> "Demand Action"]]

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


CSV.open("nov30_to_dec30.csv", "wb") do |csv|
group_newsrooms(accounts).each do |account_id, newsrooms|
  object = WeeklyReport.new(account_id, newsrooms, '2014-11-30', '2014-12-30')
  csv << object.all_data_array
  pp object.all_data_array
end
end
