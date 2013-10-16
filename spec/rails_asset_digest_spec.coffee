grunt = require("grunt")
cp    = require("child_process")
read  = grunt.file.read
write = grunt.file.write

runGruntTasks = (tasks..., done) ->
  cp.spawn("grunt", tasks, {stdio: 'inherit', cwd: 'spec'}).on "exit", -> done()

createWorkspace = (workspace) ->
  cp.exec "mkdir -p #{workspace}"

cleanWorkspace = (workspace) ->
  cp.exec "rm -rf #{workspace}"

afterEach -> cleanWorkspace("spec/tmp/")

describe "rails_asset_digest", ->
  Given -> @workspace = "spec/tmp/public/assets"
  Given -> createWorkspace(@workspace)

  describe "appends entries to an existing rails manifest", ->
    Given ->
      @existingManifest =
        """
        ---
        some/assetpipeline/generated-tree.js: some/assetpipeline/generated-tree-536a9e5ddkfjc9v9e9r939494949491.js
        another/tree-we-didnt-touch.js: another/entry-we-didnt-touch-536a9e5d711e0593e43360ad330ccc31.js
        """

      @expectedManifest =
        """
        ---
        some/assetpipeline/generated-tree.js: some/assetpipeline/generated-tree-536a9e5ddkfjc9v9e9r939494949491.js
        another/tree-we-didnt-touch.js: another/entry-we-didnt-touch-536a9e5d711e0593e43360ad330ccc31.js
        rootfile.js: rootfile-54267464ea71790d3ec68e243f64b98e.js
        sourcemapping.js.map: sourcemapping-742adbb9b78615a3c204b83965bb62f7.js.map
        othersubdirectory/generated-tree.js: othersubdirectory/generated-tree-e4ce151e4824a9cbadf1096551b070d8.js
        subdirectory/with/alibrary.js: subdirectory/with/alibrary-313b3b4b01cec6e4e82bdeeb258503c5.js
        style.css: style-7527fba956549aa7f85756bdce7183cf.css
        """

    Given -> write("#{@workspace}/manifest.yml", @existingManifest)
    Given -> @tasks = ["rails_asset_digest:appends_to_manifest_with_existing_entries"]
    Given (done) -> runGruntTasks(@tasks, done)
    Then  -> read("#{@workspace}/manifest.yml") == @expectedManifest