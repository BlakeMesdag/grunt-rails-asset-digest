'use strict';

var grunt = require('grunt');
var fs    = require('fs');
var path  = require('path');

exports.asset_digest = {
  setUp: function(done) {
    done();
  },
  appends_to_manifest_with_no_entries: function(test) {

    test.expect(1);

    var actual   = grunt.file.read('tmp/public/assets/manifest.yml');
    var expected = grunt.file.read('test/expected/manifest-with-no-entries.yml');
    test.equal(actual, expected, 'manifest with no existing entries is appended to.');

    test.done();
  }
};
