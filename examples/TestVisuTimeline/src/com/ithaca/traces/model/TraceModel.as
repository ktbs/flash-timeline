/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
 *
 * <ithaca@liris.cnrs.fr>
 *
 * This file is part of Visu.
 *
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 *
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation;
 *   either version 3 of the License, or any later version.
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 *
 * -- GNU LGPL license
 *
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 *
 * -- CeCILL-C license
 *
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use,
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info".
 *
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability.
 *
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or
 * data to be ensured and,  more generally, to use and operate it in the
 * same conditions as regards security.
 *
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 *
 * -- End of licenses
 */
package com.ithaca.traces.model
{
    import com.youtube.player.events.PlayerSharedEvent;

    /* Generated code, see below */
    public final class TraceModel
    {
       /* public static const PresenceStart: String = "PresenceStart";
        public static const PresenceEnd: String = "PresenceEnd";
        public static const RoomEnter: String = "RoomEnter";
        public static const RoomExit: String = "RoomExit";
        public static const SessionStart: String = "SessionStart";
        public static const SessionEnd: String = "SessionEnd";
        public static const ActivityStart: String = "ActivityStart";
        public static const ActivityEnd: String = "ActivityEnd";
        public static const SendKeyword: String = "SendKeyword";
        public static const ReceiveKeyword: String = "ReceiveKeyword";
        public static const SendInstructions: String = "SendInstructions";
        public static const ReceiveInstructions: String = "ReceiveInstructions";
        public static const SendDocument: String = "SendDocument";
        public static const ShowDocument: String = "ShowDocument";
        public static const ReceiveDocument: String = "ReceiveDocument";
        public static const ReadDocument: String = "ReadDocument";
        public static const StartVideo: String = "StartVideo";
        public static const PauseVideo: String = "PauseVideo";
        public static const StopVideo: String = "StopVideo";
        public static const StartWritingChatMessage: String = "StartWritingChatMessage";
        public static const SendChatMessage: String = "SendChatMessage";
        public static const ReceiveChatMessage: String = "ReceiveChatMessage";
        public static const SetMark: String = "SetMark";
        public static const DeleteMark: String = "DeleteMark";
        public static const ReceiveMark: String = "ReceiveMark";
        public static const RecordFilename: String = "RecordFilename";
        public static const ClipboardCopy: String = "ClipboardCopy";
        public static const ClipboardPaste: String = "ClipboardPaste";
        public static const LoseFocus: String = "LoseFocus";
        public static const TakeFocus: String = "TakeFocus";
        public static const TextComment: String = "TextComment";*/
        
        public static const SET_MARKER: String = "SetMarker";
        public static const RECEIVE_MARKER: String = "ReceiveMarker";
        public static const UPDATE_MARKER: String = "UpdateMarker";
        public static const SYSTEM_UPDATE_MARKER: String = "SystemUpdateMarker";
        public static const DELETE_MARKER: String = "DeleteMarker";
        public static const SYSTEM_DELETE_MARKER: String = "SystemDeleteMarker";
        public static const RECEIVE_KEYWORD: String = "ReceiveKeyword";
        public static const SEND_CHAT_MESSAGE: String = "SendChatMessage";
        public static const SEND_KEYWORD: String = "SendKeyword";
        public static const SEND_INSTRUCTIONS: String = "SendInstructions";
        public static const RECEIVE_INSTRUCTIONS: String = "ReceiveInstructions";
        public static const SEND_DOCUMENT: String = "SendDocument";
        public static const READ_DOCUMENT: String = "ReadDocument";
        public static const RECEIVE_DOCUMENT: String = "ReceiveDocument";
        public static const RECEIVE_CHAT_MESSAGE: String = "ReceiveChatMessage";
        public static const SESSION_ENTER: String = "SessionEnter";
        public static const SESSION_START: String = "SessionStart";
        public static const DISCONNECTED: String = "Disconnected";
        public static const SESSION_EXIT: String = "SessionExit";
        public static const SESSION_PAUSE: String = "SessionPause";
        public static const SESSION_OUT: String = "SessionOut";
        public static const SESSION_OUT_VOID_DURATION: String = "SessionOutVoidDuration";
        public static const SESSION_IN: String = "SessionIn";
        public static const ACTIVITY_START: String = "ActivityStart";
        public static const ACTIVITY_STOP: String = "ActivityStop";
        public static const RECORD_FILE_NAME: String = "RecordFilename";
        public static const SET_TEXT_COMMENT: String = "SetTextComment";
        public static const DELETE_TEXT_COMMENT: String = "DeleteTextComment";
        public static const UPDATE_TEXT_COMMENT: String = "UpdateTextComment";
        // get value like name obsel from PlayerSharedEvent
        public static const PLAY_VIDEO: String = PlayerSharedEvent.PLAY;
        public static const PAUSE_VIDEO: String = PlayerSharedEvent.PAUSE;
        public static const END_VIDEO: String = PlayerSharedEvent.END;
        public static const STOP_VIDEO: String = PlayerSharedEvent.STOP;
        public static const PRESS_SLIDER_VIDEO: String = PlayerSharedEvent.SLIDER_PRESS;
        public static const RELEASE_SLIDER_VIDEO: String = PlayerSharedEvent.SLIDER_RELEASE;
            
        public static const UID: String = "uid";
        public static const SENDER: String = "sender";
        public static const TEXT: String = "text";
        public static const CONTENT: String = "content";
        public static const PRESENT_IDS: String = "presentids";
        public static const PRESENT_AVATARS: String = "presentavatars";
        public static const PRESENT_NAMES: String = "presentnames";
        public static const PRESENT_COLORS: String = "presentcolors";
        public static const PRESENT_COLORS_CODE: String = "presentcolorscode";
        public static const SUBJECT: String = "subject";
        public static const KEYWORD: String = "keyword";
        public static const INSTRUCTIONS: String = "instructions";
        public static const URL: String = "url";
        public static const SENDER_DOCUMENT: String = "senderdocument";
        public static const TYPE_DOCUMENT: String = "typedocument";
        public static const ACTIVITY_ID: String = "activityid";
        public static const PATH: String = "path";
        public static const SESSION_THEME: String = "sessionTheme";
        public static const SESSION_ID: String = "session";
        public static const TIMESTAMP: String = "timestamp";
        public static const ID_DOCUMENT: String = "iddocument";
        public static const CURRENT_TIME_PLAYER: String = "currenttime";
        public static const IMAGE: String = "image";
        public static const VIDEO: String = "video";
        public static const COMMENT_FOR_USER_ID: String = "commentforuserid";
        
// RETROROOM ACTIVITY
        
        public static const RETRO_PLAY_VIDEO_EVENT: String = "RetroPlayVideo";
        public static const RETRO_PAUSE_VIDEO_EVENT: String = "RetroPauseVideoEvent";
        public static const RETRO_VIEDO_GO_TO_TIME_EVENT: String = "RetroVideoGoToTimeEvent";
        
        public static const RETRO_EXPLORE_OBSEL_EVENT: String = "RetroExploreObselEvent";
        public static const RETRO_CLICK_BUTTON_START_CREATE_COMMENT_EVENT: String = "RetroClickButtonStartCreateCommentEvent";
        public static const RETRO_DOUBLE_CLICK_TRACE_LINE_START_CREATE_COMMENT_EVENT: String = "RetroDoubleClickTraceLineStartCreateCommentEvent";
        public static const RETRO_START_EDIT_EVENT: String = "RetroStartEditEvent";
        public static const RETRO_CANCEL_EDIT_EVENT: String = "RetroCancelEditEvent";
        public static const RETRO_EDIT_TYPE_CANCEL_CREATE: String = "CREATE";
        public static const RETRO_EDIT_TYPE_CANCEL_EDIT: String = "EDIT";
        
        
    }

}

    /*
Generate above code from comment below:
perl -lne 'if (/ACTIVITIES_START/ .. /ACTIVITIES_END/) { next if /==/; if (/^(.+)\s\(/) { $n=$label=$1; $name=uc($1); $name =~ s/ /_/g; $label =~ s/\b(\w)/\U$1/g; $label =~ s/ //g; print "        public static const $label: String = \"$label\";" } }' TraceModel.as

Test coverage:
perl -lne 'print $1 if /VisuTrace.trace\("(.+?)"/' ** | sort -u

== ACTIVITIES_START ==
PresenceStart (int uid, string email, string surname, string name)
PresenceEnd ()
RoomEnter (int uid, string room, string label)
RoomExit (int uid, string room)
SessionStart (int sessionid, string label, int duration, list<string> usernames, list<int> userids, list<int> presentids, list<string> usercolors)
SessionEnd (int sessionid)
ActivityStart (int id, string label, int duration)
ActivityEnd (int id)
SendKeyword (string keyword, string room)
ReceiveKeyword (string keyword, string room, int sender)
SendInstructions (string instructions, string room)
ReceiveInstructions (string instructions, string room, int sender)
SendDocument (string url, string room)
ReceiveDocument (string url, string room, int sender)
ReadDocument (string url)
StartVideo (string url, int timestamp)
PauseVideo (string url, int timestamp)
StopVideo (string url, int timestamp)
StartWritingChatMessage ()
SendChatMessage (string message, string room)
ReceiveChatMessage (string message, string room, int sender)
SetMark (int sender, string text, int timestamp)
DeleteMark (int sender, int timestamp)
ReceiveMark (int sender, string text, int timestamp)
RecordFilename (string path, int sender)
// TODO
ClipboardCopy (string text, string origin)
ClipboardPaste (string text, string destination)
LoseFocus ()
TakeFocus ()

== ACTIVITIES_END ==

    */
