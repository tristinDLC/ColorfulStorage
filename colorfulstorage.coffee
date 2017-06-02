# You may exclude certain drives (separate with a pipe)
# Example: exclude = 'MyBook' or exclude = 'MyBook|WD Passport'
exclude   = 'NONE'

# Use base 10 numbers, i.e. 1GB = 1000MB. Leave this true to show disk sizes as
# OS X would (since Snow Leopard)
base10       = true

# appearance
filledStyle  = false # set to true for the second style variant. bgColor will become the text color

width        = '367px'
barHeight    = '36px'
labelColor   = '#fff'
audioColor   = '#fff'
moviesColor   = '#fff'
photosColor   = '#fff'
appsColor   = '#fff'
otherColor    = '#d7051d'
freeColor    = '#525252'
bgColor      = '#fff'
borderRadius = '3px'
bgOpacity    = 0.9

# You may optionally limit the number of disk to show
maxDisks: 10

command: "df -#{if base10 then 'H' else 'h'} | grep '/dev/' | while read -r line; do fs=$(echo $line | awk '{print $1}'); name=$(diskutil info $fs | grep 'Volume Name' | awk '{print substr($0, index($0,$3))}'); echo $(echo $line | awk '{print $2, $3, $4, $5}') $(echo $name | awk '{print substr($0, index($0,$1))}'); done | grep -vE '#{exclude}'"

refreshFrequency: 20000

style: """
  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  // Position this where you want
  top 10px
  left 10px

  // Statistics text settings
  color #fff
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 10px 10px 15px
  border-radius 5px

  .container
    width: 300px
    text-align: widget-align
    position: relative
    clear: both

  .container:not(:first-child)
    margin-top: 20px

  .widget-title
    text-align: widget-align

  .stats-container
    margin-bottom 5px
    border-collapse collapse

  td
    font-size: 14px
    font-weight: 300
    color: rgba(#fff, .9)
    text-shadow: 0 1px 0px rgba(#000, .7)
    text-align: widget-align

  td.pctg
    float: right

  .widget-title, p
    font-size 10px
    text-transform uppercase
    font-weight bold

  .label
    font-size 8px
    text-transform uppercase
    font-weight bold

  .bar-container
    width: 100%
    height: bar-height
    border-radius: bar-height
    float: widget-align
    clear: both
    background: rgba(#fff, .5)
    position: absolute
    margin-bottom: 5px

  .bar
    height: bar-height
    float: widget-align
    transition: width .2s ease-in-out

  .bar:first-child
    if widget-align == left
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar:last-child
    if widget-align == right
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar-other
    background: rgba(251, 212, 74, .5)

  .bar-apps
    background: rgba(73, 188, 248, .5)

  .bar-movies
    background: rgba(114, 221, 70, .5)

  .bar-audio
    background: rgba(244, 163, 64, .5)

  .bar-photos
    background: rgba(237, 66, 121, .5)

  .bar-inactive
    background: rgba(#0bf, .5)
"""

humanize: (sizeString) ->
  sizeString + 'B'


renderInfo: (other, apps, movies, audio, photos, pctg, name) -> """
  <div class="container">
    <div class="widget-title">#{name} #{@humanize(total)}</div>
    <table class="stats-container" width="100%">
      <tr>
        <td class="stat"><span class="other">#{@humanize(other)}</span></td>
        <td class="stat"><span class="apps">#{@humanize(apps)}</span></td>
        <td class="stat"><span class="movies">#{@humanize(movies)}</span></td>
        <td class="stat"><span class="audio">#{@humanize(audio)}</span></td>
        <td class="stat"><span class="photos">#{@humanize(photos)}</span></td>
        <td class="stat pctg"><span class="pctg">#{pctg}</span></td>
      </tr>
      <tr>
        <td class="label">other</td>
        <td class="label">apps</td>
        <td class="label">movies</td>
        <td class="label">audio</td>
        <td class="label">photos</td>
      </tr>
    </table>
    <div class="bar-container">
      <div class="bar bar-other" style="width: #{other}></div>
      <div class="bar bar-apps" style="width: #{apps}></div>
      <div class="bar bar-movies" style="width: #{movies}></div>
      <div class="bar bar-audio" style="width: #{audio}></div>
      <div class="bar bar-photos style="width: #{photos}"></div>
    </div>
  </div>
"""

update: (output, domEl) ->
  disks = output.split('\n')
  $(domEl).html ''

  for disk, i in disks[..(@maxDisks - 1)]
    args = disk.split(' ')
    if (args[4])
      args[4] = args[4..].join(' ')
      $(domEl).append @renderInfo(args...)

  $(domEl).append ''
