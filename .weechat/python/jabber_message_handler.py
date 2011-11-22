# -*- coding: utf-8 -*-
#
# Copyright (C) 2011 Jim Karsten <iiijjjiii@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# History:
# Version 0.07
#   2011-02-23, iiijjjiii <iiijjjiii@gmail.com>:
#   * Convert from perl to python.
# Version 0.06
#   * Log messages tagged "notify_private" (jabber messages).
# Version 0.05
#   * Use HOME env var instead of tilde.
# Version 0.04
#   * Save configuration settings in plugins.conf.
# Version 0.03
#   * Replace "our" with "my" in code. (Bug: message handling stops
#     working, requires restart)
#   * Include verbose options in help message.

SCRIPT_NAME    = 'jabber_message_handler'
SCRIPT_AUTHOR  = 'Jim Karsten <iiijjjiii@gmail.com>'
SCRIPT_VERSION = '0.07'
SCRIPT_LICENSE = 'GPL3'
SCRIPT_DESC    = 'Log highlight messages and events'
SCRIPT_COMMAND = SCRIPT_NAME

import os
import re
import subprocess
import sys
import time
import warnings

import_ok = True

try:
    import weechat
except:
    print "This script must be run under WeeChat."
    print "Get WeeChat now at: http://www.weechat.org/"
    import_ok = False

# ==============================[ global vars ]===============================

jmh_config_file = None
jmh_config_section = {}
jmh_config_option = {}

# =================================[ config ]=================================

def jmh_config_init():
    """ Initialize config file: create sections and options in memory. """
    global jmh_config_file, jmh_config_section
    jmh_config_file = weechat.config_new("jabber_message_handler",
            "jmh_config_reload_cb", "")
    if not jmh_config_file:
        return
    # options
    jmh_config_section["options"] = weechat.config_new_section(
        jmh_config_file, "options", 0, 0, "", "", "", "", "",
        "", "", "", "", "")
    if not jmh_config_section["options"]:
        weechat.config_free(jmh_config_file)
        return
    # prototype option = weechat.config_new_option(
    #    config_file, section,
    #    name, type, description,
    #    string_values, min, max, default_value, value, null_value_allowed,
    #    callback_check_value, callback_check_value_data,
    #    callback_change, callback_change_data,
    #    callback_delete, callback_delete_data)
    jmh_config_option["enabled"] = weechat.config_new_option(
        jmh_config_file, jmh_config_section["options"],
        "enabled", "boolean", "jabber_message_handler service enabled",
        "", 0, 0, "off", "off", 0,
        "", "", "", "", "", "")
    jmh_config_option["log"] = weechat.config_new_option(
        jmh_config_file, jmh_config_section["options"],
        "log", "string", "jabber_message_handler events log file",
        "", 0, 0, "~/.weechat/logs/events", "~/.weechat/logs/events", 0,
        "", "", "", "", "", "")
    jmh_config_option["verbose"] = weechat.config_new_option(
        jmh_config_file, jmh_config_section["options"],
        "verbose", "boolean", "set verbose on/off",
        "", 0, 0, "off", "off", 0,
        "", "", "", "", "", "")

def jmh_config_reload_cb(data, config_file):
    """ Reload config file. """
    return weechat.WEECHAT_CONFIG_READ_OK


def jmh_config_read():
    """ Read jabber config file (jabber.conf). """
    global jmh_config_file
    return weechat.config_read(jmh_config_file)


def jmh_config_write():
    """ Write jabber config file (jabber.conf). """
    global jmh_config_file
    return weechat.config_write(jmh_config_file)


def jmh_enabled():
    """ Return True if jmh is enabled. """
    global jmh_config_option
    if weechat.config_boolean(jmh_config_option["enabled"]):
        return True
    return False


def jmh_log():
    """ Return the jmh events log file. """
    global jmh_config_option
    return weechat.config_string(jmh_config_option["log"])


def jmh_verbose():
    """ Return True if jmh verbose is on. """
    global jmh_config_option
    if weechat.config_boolean(jmh_config_option["verbose"]):
        return True
    return False

# ================================[ commands ]================================

def jmh_hook_commands_and_completions():
    """ Hook commands and completions. """
    # prototype: hook = weechat.hook_command(command, description, args, args_description,
    #   completion, callback, callback_data)
    weechat.hook_command(SCRIPT_COMMAND, SCRIPT_DESC,
        "[ on | off | log | verbose [on|off]",
        "     on: enable jabber_message_handler\n"
        "    off: disable jabber_message_handler\n"
        "    log: name of events log file\n"
        "verbose: toggle verbose on/off\n"
        "\n"
        "Without an argument, current settings are displayed.\n"
        "\n"
        "Examples:\n"
        "List settings: /jabber_message_handler\n"
        "      Enable : /jabber_message_handler on\n"
        "     Disable : /jabber_message_handler off\n"
        "      Set log: /jabber_message_handler log /path/to/events.log\n"
        "   Verbose on: /jabber_message_handler verbose on\n"
        "  Verbose off: /jabber_message_handler verbose off\n",
        "log "
        " || off"
        " || on"
        " || verbose on|off",
        "jmh_cmd", "")

    weechat.hook_command('clr', 'Clear jabber events log.',
            '', "Usage: /clr", '', 'jmh_cmd_clr', '');

    weechat.hook_command('jabber_echo_message',
            'Echo message in jabber buffer.',
            '', "Usage: /jabber_echo_message server message",
            '%(jabber_servers)', 'jmh_cmd_jabber_echo_message', '');

    weechat.hook_completion("jabber_servers", "list of jabber servers",
                            "jmh_completion_servers", "")

def jmh_cmd(data, buffer, args=None):
    """ Command /jabber_message_handler """
    if args:
        argv = args.split(None, 1)
        if len(argv) > 0:
            if argv[0] == "on":
                weechat.config_option_set(
                        jmh_config_option["enabled"], "on", 1)
            elif argv[0] == "off":
                weechat.config_option_set(
                        jmh_config_option["enabled"], "off", 1)
            elif argv[0] == "verbose":
                if len(argv) > 1:
                    weechat.config_option_set(
                            jmh_config_option["verbose"], argv[1], 1)
                else:
                    weechat.config_option_set(
                            jmh_config_option["verbose"], "toggle", 1)
            elif argv[0] == "log":
                if len(argv) > 1:
                    weechat.config_option_set(
                            jmh_config_option["log"], argv[1], 1)
            else:
                weechat.prnt("", "jabber_message_handler: unknown action")

    print_settings()
    return weechat.WEECHAT_RC_OK


def jmh_cmd_clr(data, buffer, args=None):
    """ Command /clr """

    log = jmh_log()

    cmd = '/bin/cp -v /dev/null {log}'.format(log=log)
    if jmh_verbose():
        weechat.prnt("", "cmd: %s" % (cmd))

    # prototype hook = weechat.hook_process(command, timeout, callback,
    #   callback_data)
    process_hook = weechat.hook_process(cmd, 5000, "jmh_command_hook_cb", "")

    weechat.prnt("", 'Count cleared.')
    return weechat.WEECHAT_RC_OK


def jmh_cmd_jabber_echo_message(data, buffer, args=None):
    """ Command /jabber_echo_message """
    argv = []
    try:
        argv = args.split(None, 1)
    except:
        pass

    if not args or len(argv) < 2:
        weechat.prnt("", 'jabber_echo_message - ERROR: Invalid usage.')
        weechat.prnt("", '    See /help jabber_echo_message')
        return weechat.WEECHAT_RC_OK

    server = argv[0]
    message = ' '.join(argv[1:])

    jabber_buffer = weechat.buffer_search("python",
            'jabber.server.{s}'.format(s=server))
    if not jabber_buffer:
        weechat.prnt("",
                'jabber_echo_message - ERROR: Server "{s}" not found.'.format(
                    s=server))
        weechat.prnt("", '    For list of servers, use /jabber')
        return weechat.WEECHAT_RC_OK
    weechat.prnt_date_tags(jabber_buffer, int(time.time()), "notify_private", message)
    return weechat.WEECHAT_RC_OK


def jmh_command_hook_cb(data, command, return_code, out, err):
    if jmh_verbose():
        weechat.prnt("", "jmh_command_hook_cb called")
        weechat.prnt('', "FIXME command: {var}".format(var=command))
        weechat.prnt('', "FIXME return_code: {var}".format(var=return_code))
        weechat.prnt('', "FIXME out: {var}".format(var=out))
        weechat.prnt('', "FIXME err: {var}".format(var=err))

    if int(return_code) == weechat.WEECHAT_HOOK_PROCESS_ERROR:
        weechat.prnt("", "Error with command '%s'" % command)
        return weechat.WEECHAT_RC_OK
    if int(return_code) > 0:
        weechat.prnt("", "return_code = %d" % int(return_code))
    if jmh_verbose():
        if out != "":
            weechat.prnt("", "stdout: %s" % out)
    if err != "":
        weechat.prnt("", "stderr: %s" % err)
    return weechat.WEECHAT_RC_OK


def jmh_completion_servers(data, completion_item, buffer, completion):
    """ Completion with jabber server names. """
    infolist = weechat.infolist_get('buffer','','')
    j_re = re.compile(r'^jabber.server')
    while weechat.infolist_next(infolist):
        buffer_name = weechat.infolist_string(infolist, 'name')
        if j_re.match(buffer_name):
            # Example buffer_name = 'jabber.server.gtalk'
            names = buffer_name.split('.')
            if len(names) < 3:
                continue
            weechat.hook_completion_list_add(completion, name[2],
                                       0, weechat.WEECHAT_LIST_POS_SORT)
    weechat.infolist_free(infolist)
    return weechat.WEECHAT_RC_OK

# ==================================[ hooks ]==================================

def jmh_set_hooks():
    # prototype: hook = weechat.hook_signal(signal, callback, callback_data)
    weechat.hook_signal('weechat_highlight', 'message_highlight', '')
    weechat.hook_signal('irc_pv', 'message_private_irc', '')
    weechat.hook_signal('weechat_pv', 'message_private_weechat', '')
    # prototype: hook = weechat.hook_print(buffer, tags, message, strip_colors,
    #   callback, callback_data)
    weechat.hook_print('', 'notify_message', '', 1, 'message_weechat_print', '')


def message_highlight(data, signal, signal_data):
    if jmh_verbose():
        weechat.prnt('', 'highlight message received')
    message = parse_message(signal_data)
    message['type'] = 'highlight'
    log_event(message)
    return weechat.WEECHAT_RC_OK


def message_private_irc(data, signal, signal_data):
    if jmh_verbose():
        weechat.prnt('', 'private irc message received')
    message = parse_message(signal_data)
    message['type'] = 'highlight'
    log_event(message)
    return weechat.WEECHAT_RC_OK


def message_private_weechat(data, signal, signal_data):
    """ Eg jabber.py messages, /jabber_echo_message messages"""
    if jmh_verbose():
        weechat.prnt('', 'private weechat message received')
    message = parse_message(signal_data)
    message['type'] = 'highlight'
    log_event(message)
    return weechat.WEECHAT_RC_OK


def message_weechat_print(data, wee_buffer, date, tags, displayed, highlight,
        prefix, message):
    values = {
            'data': data,
            'buffer': wee_buffer,
            'date': date,
            'tags': tags,
            'displayed': displayed,
            'highlight': highlight,
            'prefix': prefix,
            'message': message,
            }

    if jmh_verbose():
        weechat.prnt('', 'weechat_hook_print activated (notify_message)')
        for k, v in values.items():
            weechat.prnt('', '{k}: {v}'.format(k=k, v=v))
    return weechat.WEECHAT_RC_OK


# ================================[ general ]================================

def log_event(message):
    if jmh_verbose():
        weechat.prnt('', 'Logging event.')

    log = jmh_log()

    timestamp = time.strftime("%a %b %d %H:%M:%S %Z %Y", time.localtime())

    msg = '|'.join([timestamp, message['type'], message['nick'],
            message['msg']])

    if jmh_verbose():
        weechat.prnt('', 'Logging events to {log}'.format(log=log))
        weechat.prnt('', 'log event - timestamp: {t}'.format(t=timestamp))
        weechat.prnt('', 'log event - msg: {m}'.format(m=msg))

    try:
        f = open(log, 'a')
        f.write(msg + "\n")
    except:
        weechat.prnt('', 'jabber_message_handler - Error writing log event.')
    f.close()


def parse_message(signal_data):
    if jmh_verbose():
        weechat.prnt('', 'Parsing message.')
    nick = 'n/a'
    message = 'n/a'
    parts = signal_data.split(None, 1)
    if len(parts) == 1:
        message = parts[0]
    if len(parts) == 2:
        nick = parts[0]
        message = parts[1]
    return {
             'nick': nick,
              'msg': message,
           }

def print_settings():
    weechat.prnt("", "jabber_message_handler settings:")
    if jmh_enabled():
        weechat.prnt("", "  enabled")
    else:
        weechat.prnt("", "  disabled")
    weechat.prnt("", "  events log: %s" % jmh_log())
    if jmh_verbose():
        weechat.prnt("", "  verbose: on")
    else:
        weechat.prnt("", "  verbose: off")

def process_message(data, signal, signal_data):
    message = parse_message()
    log_event(message)

# ==================================[ main ]==================================

if __name__ == "__main__" and import_ok:
    if weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION,
                        SCRIPT_LICENSE, SCRIPT_DESC,
                        "jmh_unload_script", ""):
        jmh_hook_commands_and_completions()
        jmh_config_init()
        jmh_config_read()
        jmh_set_hooks()
        print_settings()

# ==================================[ end ]===================================

def jmh_unload_script():
    """ Function called when script is unloaded. """
    jmh_config_write()
    return weechat.WEECHAT_RC_OK
