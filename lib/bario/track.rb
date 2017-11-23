# frozen_string_literal: true

require "forwardable"
require "bario/inspector"

module Bario
  # Track encapsulate all the logic to create, list, find, delete and update
  # the progress bars
  class Track
    extend Forwardable
    include Inspector

    def_delegators :track, :id, :name, :root

    inspector :id, :name, :total, :current, :root

    DEFAULT_TOTAL = 100

    class << self
      def find(id)
        track = InternalTrack[id]
        track ? new(track) : nil
      end

      def all
        collection(InternalTrack.find(root: true))
      end

      def create(name, total: DEFAULT_TOTAL, root: true, parent: nil)
        track = InternalTrack.create(name: name, total: total, root: root,
                                     parent: parent)
        parent.children.push(track) if parent
        new(track)
      end

      def collection(tracks)
        tracks.map { |x| new(x) }
      end
    end

    def initialize(track)
      @track = track
    end

    private_class_method :new

    def percent
      current / total.to_f * 100
    end

    def current
      [
        [0, track.current].max,
        total
      ].min
    end

    def total
      [0, track.total.to_i].max
    end

    def total=(val)
      track.total = val
    end

    def add_track(child_name, total: DEFAULT_TOTAL)
      new_name = "#{name}:#{child_name}"
      Track.create(new_name, total: total, root: false, parent: track)
    end

    def tracks
      self.class.collection(track.children)
    end

    def increment!(by = 1)
      track.increment(:current, by)
    end

    def decrement!(by = 1)
      track.decrement(:current, by)
    end

    def delete!
      track.parent.children.delete(track) if track.parent
      track.delete
    end

    private

    attr_reader :track

    # Internal storage backed in redis for track
    class InternalTrack < Ohm::Model
      attribute :name
      index :name

      attribute :root
      index :root

      attribute :total
      attribute :current
      counter :current

      list :children, "Bario::Track::InternalTrack"
      reference :parent, "Bario::Track::InternalTrack"
    end

    private_constant :InternalTrack
  end
end