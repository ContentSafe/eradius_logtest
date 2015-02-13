-module(tap).

-compile(export_all).

-include_lib("eradius/include/eradius_lib.hrl").
-include_lib("eradius/include/eradius_dict.hrl").
-include_lib("eradius/include/dictionary.hrl").
-include_lib("eradius/include/dictionary_3gpp.hrl").

-import(eradius_lib, [get_attr/2]).


-define(ALLOWD_USERS, [<<"test">>]).
-define(SECRET, <<"secret">>).

test() ->
    ok.

start() ->
    application:load(eradius),
    Config = [{radius_callback, eradius_server_example},
              {servers, [{root, {"127.0.0.1", [1812, 1813]}}]},
              {session_nodes, [node()]},
              {root,
                      [
                       { {"test", [] }, [{"127.0.0.1", ?SECRET}] }
                      ]
              }
             ],
    [application:set_env(eradius, Key, Value) || {Key, Value} <- Config],
    {ok, _} = application:ensure_all_started(eradius),
    {ok, spawn(fun() ->
                   eradius:modules_ready([?MODULE]),
                   timer:sleep(infinity)
               end)}.

radius_request(#radius_request{cmd = request} = Request, _NasProp, _) ->
    UserName = get_attr(Request, ?User_Name),
    case lists:member(UserName, ?ALLOWD_USERS) of
        true ->
            {reply, #radius_request{cmd = accept}};
        false ->
            {reply, #radius_request{cmd = reject}}
    end;

radius_request(#radius_request{cmd = accreq}, _NasProp, _) ->
    {reply, #radius_request{cmd = accresp}}.

client_test(UserName, NAS_IA) ->
    Request = eradius_lib:set_attributes(#radius_request{cmd = request},[
                {?NAS_Port, 8888},
                {?User_Name, UserName},
                {?NAS_IP_Address, NAS_IA},
                {?Calling_Station_Id, "447721218119"},
                {?Service_Type, 2},
                {?Framed_Protocol, 7},
                {30,"m2m.cellubi.co.uk"},               %Called-Station-Id
                {61,18},                                %NAS_PORT_TYPE
                {2, "web\0\0\0\0\0\0\0\0\0\0\0\0\0"},   %User-Password
                {{10415,1}, "1337"},                    %X_3GPP-IMSI
                {{10415,8}, "23415"},                   %X_3GPP-IMSI-MCC-MNC
                {{10415,10}, "5"},                      %X_3GPP-NSAPI
                {{10415,12}, "0"},                      %X_3GPP-Selection-Mode
                {{10415,2},75215459},                   %X_3GPP-Charging-ID
                {{10415,5},"99-1B921F739697977463FFFF"},%X_3GPP-GPRS-Negotiated-QoS-profile
                {{10415,13},"0800"},                    %X_3GPP-Charging-Characteristics
                {{10415,6},{135,211,18,192}},           %X_3GPP-SGSN-Address 
                {{10415,18},"310410"},                  %X_3GPP-SGSN-MCC-MNC 
                {{10415,7},{212,183,144,231}},          %X_3GPP-GGSN-Address 
                {{10415,9},"23415"},                    %X_3GPP-GGSN-MCC-MNC 
                {{10415,26},"0x0A"},                    %X_3GPP-Negotiated-DSCP 
                {{10415,21},"0x02"},                    %X_3GPP-RAT-Type 
                {{10415,22},"0x00130014D6F41EE8"},      %X_3GPP-User-Location-Info 
                {{10415,23},"0x2B00"},                  %X_3GPP-MS-TimeZone 
                {{10415,20},"8610240203528578"},        %X_3GPP-IMEISV 
                {{10415,3},0}                           %X_3GPP-PDP-Type
                ] ),
    case eradius_client:send_request({{127, 0, 0, 1}, 1813, ?SECRET}, Request) of
        {ok, Result} ->
            eradius_lib:decode_request(Result, ?SECRET);
        Error ->
            Error
    end.

client_test() ->
    Request = eradius_lib:set_attributes(#radius_request{cmd = request},[
                {?NAS_Port, 8888},
                {?User_Name, "test"},
                {?NAS_IP_Address, {88,88,88,88}},
                {?Calling_Station_Id, "447721218119"},
                {?Service_Type, 2},
                {?Framed_Protocol, 7},
                {30,"m2m.cellubi.co.uk"},               %Called-Station-Id
                {61,18},                                %NAS_PORT_TYPE
                {2, "web\0\0\0\0\0\0\0\0\0\0\0\0\0"},   %User-Password
                {{10415,1}, "1337"},                    %X_3GPP-IMSI
                {{10415,8}, "23415"},                   %X_3GPP-IMSI-MCC-MNC
                {{10415,10}, "5"},                      %X_3GPP-NSAPI
                {{10415,12}, "0"},                      %X_3GPP-Selection-Mode
                {{10415,2},75215459},                   %X_3GPP-Charging-ID
                {{10415,5},"99-1B921F739697977463FFFF"},%X_3GPP-GPRS-Negotiated-QoS-profile
                {{10415,13},"0800"},                    %X_3GPP-Charging-Characteristics
                {{10415,6},{135,211,18,192}},           %X_3GPP-SGSN-Address 
                {{10415,18},"310410"},                  %X_3GPP-SGSN-MCC-MNC 
                {{10415,7},{212,183,144,231}},          %X_3GPP-GGSN-Address 
                {{10415,9},"23415"},                    %X_3GPP-GGSN-MCC-MNC 
                {{10415,26},"0x0A"},                    %X_3GPP-Negotiated-DSCP 
                {{10415,21},"0x02"},                    %X_3GPP-RAT-Type 
                {{10415,22},"0x00130014D6F41EE8"},      %X_3GPP-User-Location-Info 
                {{10415,23},"0x2B00"},                  %X_3GPP-MS-TimeZone 
                {{10415,20},"8610240203528578"},        %X_3GPP-IMEISV 
                {{10415,3},0}                           %X_3GPP-PDP-Type
                ] ),
    case eradius_client:send_request({{127, 0, 0, 1}, 1813, ?SECRET}, Request) of
        {ok, Result} ->
            eradius_lib:decode_request(Result, ?SECRET);
        Error ->
            Error
    end.