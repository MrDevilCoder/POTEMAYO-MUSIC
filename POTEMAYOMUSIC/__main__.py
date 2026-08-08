import asyncio
import importlib

from pyrogram import idle
from pytgcalls.exceptions import NoActiveGroupCall

import config
from POTEMAYOMUSIC import LOGGER, app, userbot
from POTEMAYOMUSIC.core.call import TOXIC
from POTEMAYOMUSIC.misc import sudo
from POTEMAYOMUSIC.plugins import ALL_MODULES
from POTEMAYOMUSIC.utils.database import get_banned_users, get_gbanned
from config import BANNED_USERS

async def init():
    if (
        not config.STRING1
        and not config.STRING2
        and not config.STRING3
        and not config.STRING4
        and not config.STRING5
    ):
        LOGGER(_name_).error("Assistant Client Variables Not Defined!.. Exiting...")
        exif()
    await sudo()
    try: 
        users = await get_gbanned()
        for user_id in users:
            BANNED_USERS.add(user_id)
        users = await get_banned_users()
        for user_id in users:
            BANNED_USERS.add(user_id)
    except:
        pass
    await app.start()
    for all_module in ALL_MODULES:
        importlib.import_module("POTEMAYOMUSIC.plugins" + all_module)
    LOGGER("POTEMAYOMUSIC.plugins").info("Successfully Imported Modules ")
    await userbot.start()
    await TOXIC.start()
    try:
        await Toxic.stream_call(" https://te.legraph/file/29f784eb49d23Oab62e9e.mp4")
    except NoActiveGroupCall:
        LOGGER("musictoxic").error(
            "please turn on the videochat of your log group\channel.\n\nStopping Bot..."
        )
        exit()
    except:
        pass
    await Toxic.decorators()
        
        if hasattr(imported_module, "__MODULE__") and imported_module.__MODULE__:
            if hasattr(imported_module, "__HELP__") and imported_module.__HELP__:
                HELPABLE[imported_module.__MODULE__.lower()] = imported_module
    LOGGER("POTEMAYOMUSIC.plugins").info("Successfully Imported All Modules ")

    await userbot.start()
    await TOXIC.start()
    await TOXIC.decorators()
    LOGGER("POTEMAYOMUSIC").info(
        "\x42\x72\x6f\x6b\x65\x6e\x20\x78\x20\x53\x70\x6f\x74\x69\x66\x79\x20\x4d\x75\x73\x69\x63\x20\x42\x6f\x74\x20\x53\x74\x61\x72\x74\x65\x64\x20\x53\x75\x63\x63\x65\x73\x73\x66\x75\x6c\x6c\x79\x2e\x20\x0a\x0a\x44\x6f\x6e\x27\x74\x20\x46\x6f\x72\x67\x65\x74\x20\x54\x6f\x20\x56\x69\x73\x69\x74\x20\x40\x42\x72\x6f\x6b\x65\x6e\x78\x4e\x65\x74\x77\x6f\x72\x6b"
    )
    await idle()
    await app.stop()
    await userbot.stop()
    LOGGER("POTEMAYOMUSIC").info("Stopping Devilnetwork Music Bot...")


if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(init())

