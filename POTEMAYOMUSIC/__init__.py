from POTEMAYOMUSIC.core.bot import Potemayo
from POTEMAYOMUSIC.core.dir import dirr
from POTEMAYOMUSIC.core.git import git
from POTEMAYOMUSIC.core.userbot import Userbot
from POTEMAYOMUSIC.misc import dbb, heroku

from .logging import LOGGER

dirr()
git()
dbb()
heroku()

app = potemayo()

userbot = Userbot()

from .platforms import *

YouTube = YouTubeAPI()
Carbon = CarbonAPI()
Spotify = SpotifyAPI()
Apple = AppleAPI()
Resso = RessoAPI()
SoundCloud = SoundAPI()
Telegram = TeleAPI()
