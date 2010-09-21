%%% ====================================================================
%%% ``The contents of this file are subject to the Erlang Public License,
%%% Version 1.1, (the "License"); you may not use this file except in
%%% compliance with the License. You should have received a copy of the
%%% Erlang Public License along with this software. If not, it can be
%%% retrieved via the world wide web at http://www.erlang.org/.
%%% 
%%% Software distributed under the License is distributed on an "AS IS"
%%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%%% the License for the specific language governing rights and limitations
%%% under the License.
%%% 
%%% The Initial Developer of the Original Code is ProcessOne.
%%% Portions created by ProcessOne are Copyright 2006-2010, ProcessOne
%%% All Rights Reserved.''
%%% This software is copyright 2006-2010, ProcessOne.
%%%
%%%
%%% copyright 2006-2010 ProcessOne
%%%
%%% This file contains pubsub types definition.
%%% ====================================================================


-include_lib("exmpp/include/exmpp.hrl").
-include_lib("exmpp/include/exmpp_jid.hrl").


%% -------------------------------
%% Pubsub constants
-define(ERR_EXTENDED(E,C), mod_pubsub:extended_error(E,C)).

%% The actual limit can be configured with mod_pubsub's option max_items_node
-define(MAXITEMS, 10).

%% this is currently a hard limit.
%% Would be nice to have it configurable. 
-define(MAX_PAYLOAD_SIZE, 60000).


%% ------------
%% Pubsub types
%% ------------

%%% @type host() = binary().
%%%
%%% <p><tt>host</tt> is the name of the PubSub service. For example, it can be
%%% <tt>pubsub.localhost</tt>.</p>

-type(host() :: binary()).


%%% @type nodeId() = binary().
%%%
%%% <p>A <tt>nodeId</tt> is the name of a Node. It can be anything and may represent
%%% some hierarchical tree depending of the node type.
%%% For example:
%%%   /home/localhost/user/node
%%%   princely_musings
%%%   http://jabber.org/protocol/tune
%%%   My-Own_Node</p>

-type(nodeId() :: binary()).


%%% @type itemId() = binary().
%%%
%%% <p>An <tt>itemId</tt> is the name of an Item. It can be anything.
%%% For example:
%%%   38964
%%%   my-tune
%%%   FD6SBE6a27d</p>

-type(itemId() :: binary()).


%%% @type subId() = binary().

-type(subId() :: binary()).


%%% @type nodeType() = string().
%%%
%%% <p>The <tt>nodeType</tt> is a string containing the name of the PubSub
%%% plugin to use to manage a given node. For example, it can be
%%% <tt>"flat"</tt>, <tt>"hometree"</tt> or <tt>"blog"</tt>.</p>

-type(nodeType() :: string()).


%%% @type ljid() = {User::binary(), Server::binary(), Resource::binary()}.

-type(ljid() :: {User::binary(), Server::binary(), Resource::binary()}).


%%% @type nodeIdx() = integer().

-type(nodeIdx() :: integer()).


%%% @type now() = {Megaseconds::integer(), Seconds::integer(), Microseconds::integer()}.

-type(now() :: {Megaseconds::integer(), Seconds::integer(), Microseconds::integer()}).


%%% @type affiliation() = none | owner | publisher | member | outcast.

-type(affiliation() :: none | owner | publisher | member | outcast).


%%% @type subscription() = none | pending | unconfigured | subscribed.

-type(subscription() ::  none | pending | unconfigured | subscribed).


%%% @type payload() = string().

-type(payload() :: string()).


%%% @type stanzaError() = #xmlel{}.
%%%
%%% Example: 
%%%    ```#xmlel{name = 'error'
%%%              ns = ?NS_STANZAS,
%%%              attrs = [
%%%                #xmlattr{
%%%                  name = 'code',
%%%                  ns = ?NS_STANZAS,
%%%                  value = Code
%%%                },
%%%              attrs = [
%%%                #xmlattr{
%%%                  name = 'type',
%%%                  ns = ?NS_STANZAS,
%%%                  value = Type
%%%                }
%%%              ]}'''

-type(stanzaError() :: #xmlel{}).


%%% @type pubsubIQResponse() = #xmlel{}.
%%%
%%% Example:
%%%    ```#xmlel{name = 'pubsub',
%%%              ns = ?NS_PUBSUB,
%%%              children = [
%%%                #xmlel{name = 'affiliations'
%%%                       ns = ?NS_PUBSUB
%%%                }
%%%              ]
%%%             }'''

-type(pubsubIQResponse() :: #xmlel{}).


%%% @type nodeOption() = {Option, Value}.
%%%    Option = atom()
%%%    Value = term().
%%%
%%% Example:
%%% ```{deliver_payloads, true}'''

-type(nodeOption() :: {Option::atom(), Value::term()}).

%%% @type subOption() = {Option, Value}.
%%%    Option = atom()
%%%    Value = term().

-type(subOption() :: {Option::atom(), Value::term()}).


%%% @type pubsubIndex() = {pubsub_index, Index, Last, Free}.
%%%    Index = atom()
%%%    Last  = nodeIdx()
%%%    Free  = [nodeIdx()].
%%%
%%% Internal pubsub index table.

-record(pubsub_index,
{
  index :: atom(),
  last  :: integer(),
  free  :: [integer()]
}).

-type(pubsubIndex() :: #pubsub_index{}).


%%% @type pubsubNode() = {pubsub_node, Id, Idx, Parents, Type, Owners, Options}
%%%    Id      = {host(), nodeId()}
%%%    Idx     = nodeIdx()
%%%    Parents = [nodeId()]
%%%    Type    = nodeType()
%%%    Owners  = [ljid()]
%%%    Options = [nodeOption()].
%%%
%%% <p>This is the format of the <tt>nodes</tt> table. The type of the table
%%% is: <tt>set</tt>,<tt>ram/disc</tt>.</p>
%%% <p>The <tt>parents</tt> and <tt>type</tt> fields are indexed.</p>
%%% <p><tt>idx</tt> is an integer.</p>

-record(pubsub_node,
{
  id               :: {host(), nodeId()},
  idx              :: nodeIdx(),
  parents = []     :: [nodeId()],
  type    = "flat" :: nodeType(),
  owners  = []     :: [ljid()],
  options = []     :: [nodeOption()]
}).

-type(pubsubNode() :: #pubsub_node{}).


%%% @type pubsubState() = {pubsub_state, Id, Items, Affiliation, Subscriptions}
%%%    Id            = {ljid(), nodeIdx()}
%%%    Items         = [itemId()]
%%%    Affiliation   = affiliation()
%%%    Subscriptions = [subscription()].
%%%
%%% <p>This is the format of the <tt>affiliations</tt> table. The type of the
%%% table is: <tt>set</tt>,<tt>ram/disc</tt>.</p>

-record(pubsub_state,
{
  id                   :: {ljid(), nodeIdx()},
  items         = []   :: [itemId()],
  affiliation   = none :: affiliation(),
  subscriptions = []   :: [subscription()]
}).

-type(pubsubState() :: #pubsub_state{}).


%%% @type pubsubItem() = {pubsub_item, Id, Creation, Modification, Payload}
%%%    Id           = {itemId(), nodeIdx()}
%%%    Creation     = {now(), ljid()}
%%%    Modification = {now(), ljid()}
%%%    Payload      = payload().
%%%
%%% <p>This is the format of the <tt>published items</tt> table. The type of the
%%% table is: <tt>set</tt>,<tt>disc</tt>,<tt>fragmented</tt>.</p>

-record(pubsub_item,
{
  id                               :: {itemId(), nodeIdx()},
  creation     = {unknown,unknown} :: {now(), ljid()},
  modification = {unknown,unknown} :: {now(), ljid()},
  payload      = []                :: payload()
}).

-type(pubsubItem() :: #pubsub_item{}).


%%% @type pubsubSubscription() = {pubsub_subscription, SubId, Options}
%%%    SubId   = subId()
%%%    Options = [nodeOption()].
%%%
%% <p>This is the format of the <tt>subscriptions</tt> table. The type of the
%% table is: <tt>set</tt>,<tt>ram/disc</tt>.</p>

-record(pubsub_subscription,
{
  subid   :: subId(),
  options :: [subOption()]
}).

-type(pubsubSubscription() :: #pubsub_subscription{}).


%%% @type pubsubLastItem() = {pubsub_last_item, NodeId, ItemId, Creation, Payload}
%%%    NodeId   = nodeIdx()
%%%    ItemId   = itemId()
%%%    Creation = {now(), ljid()}
%%%    Payload   = payload().
%%%
%% <p>This is the format of the <tt>last items</tt> table. it stores last item payload
%% for every node</p>

-record(pubsub_last_item,
{
  nodeid   :: nodeIdx(),
  itemid   :: itemId(),
  creation :: {now(), ljid()},
  payload  :: payload()
}).

-type(pubsubLastItem() :: #pubsub_last_item{}).
