_ = require 'underscore'
Backbone = require 'backbone'
Article = require '../../models/article.coffee'
sinon = require 'sinon'
fixtures = require '../../../test/helpers/fixtures'

describe "Article", ->

  beforeEach ->
    sinon.stub Backbone, 'sync'
    @article = new Article fixtures().articles

  afterEach ->
    Backbone.sync.restore()

  describe '#initialize', ->

    it 'sets up a related sections collection', ->
      @article.sections.length.should.equal 6

  describe '#toJSON', ->

    it 'loops the sections collection back in', ->
      @article.sections.reset { body: 'Foobar' }
      @article.toJSON().sections[0].body.should.equal 'Foobar'

    it 'sections fall back to attrs', ->
      @article.set sections: [{ body: 'Foobar' }]
      @article.sections.reset []
      @article.toJSON().sections[0].body.should.equal 'Foobar'

    it 'injects features artworks & artists', ->
      @article.featuredArtworks.set [fixtures().artworks]
      @article.featuredArtists.set [fixtures().artists]
      @article.featuredPrimaryArtists.set [fixtures().artists]
      @article.toJSON().featured_artwork_ids.length.should.equal 1
      @article.toJSON().featured_artist_ids.length.should.equal 1
      @article.toJSON().primary_featured_artist_ids.length.should.equal 1

  describe '#finishedContent', ->

    it 'returns true if theres a title', ->
      @article.set title: 'foo'
      @article.finishedContent().should.be.ok

    it 'returns true if finished all thumbnail stuff', ->
      @article.set
        thumbnail_title: 'bar'
        thumbnail_image: 'foo.jpg'
        thumbnail_teaser: 'baz'
        tags: ['foo']
      @article.finishedThumbnail().should.be.ok

  describe '#featuredList', ->

    it 'returns a mapped list of featured/mentioned artists ordered by name', ->
      @article.mentionedArtists.reset(
        [
          _.extend(fixtures().artists, id: 'andy', name: 'Andy')
          _.extend(fixtures().artists, id: 'charles', name: 'Charles')
        ])
      @article.featuredArtists.reset(
        [
          _.extend(fixtures().artists, id: 'bob', name: 'Bob')
        ])
      _.map(@article.featuredList('Artists'), (i) -> i.model.id).join('')
        .should.equal 'andybobcharles'
      _.map(@article.featuredList('Artists'), (i) -> String i.featured).join('')
        .should.equal 'falsetruefalse'
