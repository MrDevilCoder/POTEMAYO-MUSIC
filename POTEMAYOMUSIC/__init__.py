import json
import os

from POTEMAYOMUSIC.core.bot import potemyaobot
from POTEMAYOMUSIC.core.dir import dirr
from POTEMAYOMUSIC.core.git import git
from POTEMAYOMUSIC.core.userbot import Userbot
from POTEMAYOMUSIC.core.youtube import toxicxd
from POTEMAYOMUSIC.misc import dbb, heroku, sudo

from .logging import LOGGER

dirr()

git()

dbb()

heroku()

sudo()

toxicxd()

app = potemayoBot()

userbot = Userbot()

from .platforms import *

YouTube = YouTubeAPI()
Carbon = CarbonAPI()
Spotify = SpotifyAPI()
Apple = AppleAPI()
Resso = RessoAPI()
SoundCloud = SoundAPI()
Telegram = TeleAPI()
HELPABLE = {}
