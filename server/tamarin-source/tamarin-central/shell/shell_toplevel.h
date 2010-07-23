/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is [Open Source Virtual Machine].
 *
 * The Initial Developer of the Original Code is
 * Adobe System Incorporated.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Adobe AS3 Team
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */
/* machine generated file -- do not edit */
#define AVMTHUNK_VERSION 4
extern const uint32_t shell_toplevel_abc_class_count;
extern const uint32_t shell_toplevel_abc_script_count;
extern const uint32_t shell_toplevel_abc_method_count;
extern const uint32_t shell_toplevel_abc_length;
extern const uint8_t shell_toplevel_abc_data[];
AVMTHUNK_DECLARE_NATIVE_INITIALIZER(shell_toplevel)
/* classes */
const uint32_t abcclass_avmplus_ITest = 0;
const uint32_t abcclass_avmplus_CTest = 1;
const uint32_t abcclass_avmplus_System = 2;
const uint32_t abcclass_avmplus_File = 3;
const uint32_t abcclass_flash_system_Capabilities = 4;
const uint32_t abcclass_flash_sampler_StackFrame = 5;
const uint32_t abcclass_flash_sampler_Sample = 6;
const uint32_t abcclass_flash_trace_Trace = 7;
const uint32_t abcclass_flash_utils_Dictionary = 8;
const uint32_t abcclass_flash_events_Event = 9;
const uint32_t abcclass_flash_events_IEventDispatcher = 10;
const uint32_t abcclass_flash_utils_ByteArray = 11;
const uint32_t abcclass_avmplus_Domain = 12;
const uint32_t abcclass_avmplus_StringBuilder = 13;
const uint32_t abcclass_com_adobe_errors_IllegalStateError = 14;
const uint32_t abcclass_com_adobe_net_IURIResolver = 15;
const uint32_t abcclass_com_adobe_net_MimeTypeMap = 16;
const uint32_t abcclass_com_adobe_net_URI = 17;
const uint32_t abcclass_com_adobe_serialization_json_JSON = 18;
const uint32_t abcclass_com_adobe_serialization_json_JSONDecoder = 19;
const uint32_t abcclass_com_adobe_serialization_json_JSONEncoder = 20;
const uint32_t abcclass_com_adobe_serialization_json_JSONParseError = 21;
const uint32_t abcclass_com_adobe_serialization_json_JSONToken = 22;
const uint32_t abcclass_com_adobe_serialization_json_JSONTokenizer = 23;
const uint32_t abcclass_com_adobe_serialization_json_JSONTokenType = 24;
const uint32_t abcclass_com_adobe_utils_ArrayUtil = 25;
const uint32_t abcclass_com_adobe_utils_DictionaryUtil = 26;
const uint32_t abcclass_com_adobe_utils_IntUtil = 27;
const uint32_t abcclass_com_adobe_utils_NumberFormatter = 28;
const uint32_t abcclass_com_adobe_utils_StringUtil = 29;
const uint32_t abcclass_com_adobe_utils_XMLUtil = 30;
const uint32_t abcclass_de_polygonal_ds_Collection = 31;
const uint32_t abcclass_de_polygonal_ds_Iterator = 32;
const uint32_t abcclass_flash_display_StageQuality = 33;
const uint32_t abcclass_flash_errors_EOFError = 34;
const uint32_t abcclass_flash_errors_IllegalOperationError = 35;
const uint32_t abcclass_flash_errors_IOError = 36;
const uint32_t abcclass_flash_errors_MemoryError = 37;
const uint32_t abcclass_flash_geom_Matrix = 38;
const uint32_t abcclass_flash_geom_Point = 39;
const uint32_t abcclass_flash_geom_Rectangle = 40;
const uint32_t abcclass_flash_net_ObjectEncoding = 41;
const uint32_t abcclass_flash_utils_IDataInput = 42;
const uint32_t abcclass_flash_utils_IDataOutput = 43;
const uint32_t abcclass_flash_net_URLLoaderDataFormat = 44;
const uint32_t abcclass_flash_net_URLRequest = 45;
const uint32_t abcclass_flash_utils_Endian = 46;
const uint32_t abcclass_flash_utils_IExternalizable = 47;
const uint32_t abcclass_private_Buddy = 48;
const uint32_t abcclass_mx_core_IChildList = 49;
const uint32_t abcclass_mx_core_IRawChildrenContainer = 50;
const uint32_t abcclass_mx_resources_IResourceBundle = 51;
const uint32_t abcclass_mx_resources_IResourceManager = 52;
const uint32_t abcclass_mx_resources_Locale = 53;
const uint32_t abcclass_mx_resources_ResourceManager = 54;
const uint32_t abcclass_org_httpclient_HttpRequest = 55;
const uint32_t abcclass_org_httpclient_events_HttpListener = 56;
const uint32_t abcclass_org_httpclient_http_multipart_Multipart = 57;
const uint32_t abcclass_org_httpclient_http_multipart_Part = 58;
const uint32_t abcclass_org_httpclient_HttpHeader = 59;
const uint32_t abcclass_org_httpclient_HttpResponse = 60;
const uint32_t abcclass_org_httpclient_HttpSocket = 61;
const uint32_t abcclass_org_httpclient_HttpTimer = 62;
const uint32_t abcclass_org_httpclient_io_HttpBuffer = 63;
const uint32_t abcclass_org_httpclient_io_HttpRequestBuffer = 64;
const uint32_t abcclass_org_httpclient_io_HttpResponseBuffer = 65;
const uint32_t abcclass_org_httpclient_Log = 66;
const uint32_t abcclass_Thane = 67;
const uint32_t abcclass_private_SpawnedDomain = 68;
const uint32_t abcclass_Thanette = 69;
const uint32_t abcclass_flash_sampler_NewObjectSample = 70;
const uint32_t abcclass_flash_sampler_DeleteObjectSample = 71;
const uint32_t abcclass_flash_events_TextEvent = 72;
const uint32_t abcclass_flash_events_KeyboardEvent = 73;
const uint32_t abcclass_flash_events_MouseEvent = 74;
const uint32_t abcclass_flash_events_NetStatusEvent = 75;
const uint32_t abcclass_flash_events_ProgressEvent = 76;
const uint32_t abcclass_flash_events_TimerEvent = 77;
const uint32_t abcclass_org_httpclient_events_HttpDataEvent = 78;
const uint32_t abcclass_org_httpclient_events_HttpStatusEvent = 79;
const uint32_t abcclass_TraceEvent = 80;
const uint32_t abcclass_flash_events_EventDispatcher = 81;
const uint32_t abcclass_com_adobe_net_URIEncodingBitmap = 82;
const uint32_t abcclass_de_polygonal_ds_Heap = 83;
const uint32_t abcclass_private_HeapIterator = 84;
const uint32_t abcclass_org_httpclient_http_Delete = 85;
const uint32_t abcclass_org_httpclient_http_Get = 86;
const uint32_t abcclass_org_httpclient_http_Head = 87;
const uint32_t abcclass_org_httpclient_http_Post = 88;
const uint32_t abcclass_org_httpclient_http_Put = 89;
const uint32_t abcclass_flash_events_ErrorEvent = 90;
const uint32_t abcclass_flash_display_DisplayObject = 91;
const uint32_t abcclass_flash_display_LoaderInfo = 92;
const uint32_t abcclass_flash_net_Socket = 93;
const uint32_t abcclass_flash_net_URLLoader = 94;
const uint32_t abcclass_flash_utils_Timer = 95;
const uint32_t abcclass_org_httpclient_HttpClient = 96;
const uint32_t abcclass_flash_events_HTTPStatusEvent = 97;
const uint32_t abcclass_flash_events_IOErrorEvent = 98;
const uint32_t abcclass_flash_events_SecurityErrorEvent = 99;
const uint32_t abcclass_org_httpclient_events_HttpErrorEvent = 100;
const uint32_t abcclass_flash_display_DisplayObjectContainer = 101;
const uint32_t abcclass_flash_display_Loader = 102;
/* methods */
const uint32_t flash_sampler_isGetterSetter = 11;
const uint32_t flash_sampler__getInvocationCount = 12;
const uint32_t flash_sampler_getSampleCount = 16;
const uint32_t flash_sampler_getSamples = 17;
const uint32_t flash_sampler_getMemberNames = 18;
const uint32_t flash_sampler_getSize = 19;
const uint32_t flash_sampler__setSamplerCallback = 20;
const uint32_t flash_sampler_sampleInternalAllocs = 23;
const uint32_t flash_sampler_pauseSampling = 24;
const uint32_t flash_sampler_stopSampling = 25;
const uint32_t flash_sampler_startSampling = 26;
const uint32_t flash_sampler_clearSamples = 27;
const uint32_t avmplus_System_exit = 40;
const uint32_t avmplus_System_exec = 41;
const uint32_t avmplus_System_getAvmplusVersion = 42;
const uint32_t avmplus_System_trace = 43;
const uint32_t avmplus_System_write = 44;
const uint32_t avmplus_System_debugger = 45;
const uint32_t avmplus_System_isDebugger = 46;
const uint32_t avmplus_System_getTimer = 47;
const uint32_t avmplus_System_private_getArgv = 48;
const uint32_t avmplus_System_readLine = 49;
const uint32_t avmplus_System_totalMemory_get = 50;
const uint32_t avmplus_System_freeMemory_get = 51;
const uint32_t avmplus_System_privateMemory_get = 52;
const uint32_t avmplus_System_setHeartbeatCallback = 53;
const uint32_t avmplus_System_ns_example_nstest = 54;
const uint32_t avmplus_System_isGlobal = 55;
const uint32_t avmplus_File_exists = 58;
const uint32_t avmplus_File_read = 59;
const uint32_t avmplus_File_write = 60;
const uint32_t flash_trace_Trace_setLevel = 74;
const uint32_t flash_trace_Trace_getLevel = 75;
const uint32_t flash_trace_Trace_setListener = 76;
const uint32_t flash_trace_Trace_getListener = 77;
const uint32_t flash_utils_Dictionary_private_init = 80;
const uint32_t flash_utils_ByteArray_readFile = 101;
const uint32_t flash_utils_ByteArray_writeFile = 102;
const uint32_t flash_utils_ByteArray_readBytes = 103;
const uint32_t flash_utils_ByteArray_writeBytes = 104;
const uint32_t flash_utils_ByteArray_writeBoolean = 105;
const uint32_t flash_utils_ByteArray_writeByte = 106;
const uint32_t flash_utils_ByteArray_writeShort = 107;
const uint32_t flash_utils_ByteArray_writeInt = 108;
const uint32_t flash_utils_ByteArray_writeUnsignedInt = 109;
const uint32_t flash_utils_ByteArray_writeFloat = 110;
const uint32_t flash_utils_ByteArray_writeDouble = 111;
const uint32_t flash_utils_ByteArray_writeUTF = 112;
const uint32_t flash_utils_ByteArray_writeUTFBytes = 113;
const uint32_t flash_utils_ByteArray_readBoolean = 114;
const uint32_t flash_utils_ByteArray_readByte = 115;
const uint32_t flash_utils_ByteArray_readUnsignedByte = 116;
const uint32_t flash_utils_ByteArray_readShort = 117;
const uint32_t flash_utils_ByteArray_readUnsignedShort = 118;
const uint32_t flash_utils_ByteArray_readInt = 119;
const uint32_t flash_utils_ByteArray_readUnsignedInt = 120;
const uint32_t flash_utils_ByteArray_readFloat = 121;
const uint32_t flash_utils_ByteArray_readDouble = 122;
const uint32_t flash_utils_ByteArray_readUTF = 123;
const uint32_t flash_utils_ByteArray_readUTFBytes = 124;
const uint32_t flash_utils_ByteArray_length_get = 125;
const uint32_t flash_utils_ByteArray_length_set = 126;
const uint32_t flash_utils_ByteArray_private_zlib_compress = 127;
const uint32_t flash_utils_ByteArray_private_zlib_uncompress = 129;
const uint32_t flash_utils_ByteArray_private__toString = 131;
const uint32_t flash_utils_ByteArray_bytesAvailable_get = 133;
const uint32_t flash_utils_ByteArray_position_get = 134;
const uint32_t flash_utils_ByteArray_position_set = 135;
const uint32_t flash_utils_ByteArray_endian_get = 136;
const uint32_t flash_utils_ByteArray_endian_set = 137;
const uint32_t avmplus_Domain_currentDomain_get = 140;
const uint32_t avmplus_Domain_MIN_DOMAIN_MEMORY_LENGTH_get = 141;
const uint32_t avmplus_Domain_private_init = 142;
const uint32_t avmplus_Domain_loadBytes = 144;
const uint32_t avmplus_Domain_getClass = 145;
const uint32_t avmplus_Domain_getClassName = 146;
const uint32_t avmplus_Domain_domainMemory_get = 148;
const uint32_t avmplus_Domain_domainMemory_set = 149;
const uint32_t avmplus_StringBuilder_append = 152;
const uint32_t avmplus_StringBuilder_capacity_get = 153;
const uint32_t avmplus_StringBuilder_charAt = 154;
const uint32_t avmplus_StringBuilder_charCodeAt = 155;
const uint32_t avmplus_StringBuilder_ensureCapacity = 156;
const uint32_t avmplus_StringBuilder_indexOf = 157;
const uint32_t avmplus_StringBuilder_insert = 158;
const uint32_t avmplus_StringBuilder_lastIndexOf = 159;
const uint32_t avmplus_StringBuilder_length_get = 160;
const uint32_t avmplus_StringBuilder_length_set = 161;
const uint32_t avmplus_StringBuilder_remove = 162;
const uint32_t avmplus_StringBuilder_removeCharAt = 163;
const uint32_t avmplus_StringBuilder_replace = 164;
const uint32_t avmplus_StringBuilder_reverse = 165;
const uint32_t avmplus_StringBuilder_setCharAt = 166;
const uint32_t avmplus_StringBuilder_substring = 167;
const uint32_t avmplus_StringBuilder_toString = 168;
const uint32_t avmplus_StringBuilder_trimToSize = 169;
const uint32_t flash_sampler_NewObjectSample_object_get = 615;
const uint32_t flash_sampler_NewObjectSample_size_get = 616;
const uint32_t flash_net_Socket_private_nb_disconnect = 718;
const uint32_t flash_net_Socket_private_nb_connect = 719;
const uint32_t flash_net_Socket_private_nb_read = 720;
const uint32_t flash_net_Socket_private_nb_write = 721;
const uint32_t flash_net_Socket_listen = 722;
const uint32_t flash_net_Socket_accept = 723;
const uint32_t flash_net_Socket_hasConnection = 724;
extern double shell_toplevel_d2d_o_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_sampler_NewObjectSample_size_get_thunk  shell_toplevel_d2d_o_thunk
#define avmplus_System_freeMemory_get_thunk  shell_toplevel_d2d_o_thunk
#define avmplus_System_privateMemory_get_thunk  shell_toplevel_d2d_o_thunk
#define flash_sampler_getSampleCount_thunk  shell_toplevel_d2d_o_thunk
#define flash_utils_ByteArray_readFloat_thunk  shell_toplevel_d2d_o_thunk
#define avmplus_System_totalMemory_get_thunk  shell_toplevel_d2d_o_thunk
#define flash_utils_ByteArray_readDouble_thunk  shell_toplevel_d2d_o_thunk

extern AvmBox shell_toplevel_v2a_oouu_opti0_opti0_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_writeBytes_thunk  shell_toplevel_v2a_oouu_opti0_opti0_thunk
#define flash_utils_ByteArray_readBytes_thunk  shell_toplevel_v2a_oouu_opti0_opti0_thunk

extern AvmBox shell_toplevel_a2a_os_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_readFile_thunk  shell_toplevel_a2a_os_thunk
#define avmplus_Domain_getClass_thunk  shell_toplevel_a2a_os_thunk

extern AvmBox shell_toplevel_u2a_ou_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_charCodeAt_thunk  shell_toplevel_u2a_ou_thunk

extern AvmBox shell_toplevel_a2a_ou_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_length_set_thunk  shell_toplevel_a2a_ou_thunk

extern AvmBox shell_toplevel_v2a_oa_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_append_thunk  shell_toplevel_v2a_oa_thunk

extern AvmBox shell_toplevel_a2a_oo_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_Domain_loadBytes_thunk  shell_toplevel_a2a_oo_thunk
#define avmplus_Domain_domainMemory_set_thunk  shell_toplevel_a2a_oo_thunk
#define flash_trace_Trace_setListener_thunk  shell_toplevel_a2a_oo_thunk

extern AvmBox shell_toplevel_s2a_o_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_System_readLine_thunk  shell_toplevel_s2a_o_thunk
#define flash_utils_ByteArray_endian_get_thunk  shell_toplevel_s2a_o_thunk
#define flash_utils_ByteArray_readUTF_thunk  shell_toplevel_s2a_o_thunk
#define flash_utils_ByteArray_private__toString_thunk  shell_toplevel_s2a_o_thunk
#define avmplus_System_getAvmplusVersion_thunk  shell_toplevel_s2a_o_thunk
#define avmplus_StringBuilder_toString_thunk  shell_toplevel_s2a_o_thunk

extern AvmBox shell_toplevel_v2a_ou_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_ensureCapacity_thunk  shell_toplevel_v2a_ou_thunk
#define flash_utils_ByteArray_position_set_thunk  shell_toplevel_v2a_ou_thunk
#define avmplus_StringBuilder_removeCharAt_thunk  shell_toplevel_v2a_ou_thunk
#define flash_utils_ByteArray_length_set_thunk  shell_toplevel_v2a_ou_thunk
#define flash_utils_ByteArray_writeUnsignedInt_thunk  shell_toplevel_v2a_ou_thunk

extern AvmBox shell_toplevel_v2a_oss_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_File_write_thunk  shell_toplevel_v2a_oss_thunk

extern AvmBox shell_toplevel_b2a_oao_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_sampler_isGetterSetter_thunk  shell_toplevel_b2a_oao_thunk

extern AvmBox shell_toplevel_v2a_ous_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_setCharAt_thunk  shell_toplevel_v2a_ous_thunk

extern AvmBox shell_toplevel_u2a_o_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_readUnsignedShort_thunk  shell_toplevel_u2a_o_thunk
#define flash_utils_ByteArray_bytesAvailable_get_thunk  shell_toplevel_u2a_o_thunk
#define flash_utils_ByteArray_length_get_thunk  shell_toplevel_u2a_o_thunk
#define avmplus_StringBuilder_length_get_thunk  shell_toplevel_u2a_o_thunk
#define flash_utils_ByteArray_readUnsignedInt_thunk  shell_toplevel_u2a_o_thunk
#define flash_utils_ByteArray_readUnsignedByte_thunk  shell_toplevel_u2a_o_thunk
#define avmplus_StringBuilder_capacity_get_thunk  shell_toplevel_u2a_o_thunk
#define avmplus_Domain_MIN_DOMAIN_MEMORY_LENGTH_get_thunk  shell_toplevel_u2a_o_thunk
#define avmplus_System_getTimer_thunk  shell_toplevel_u2a_o_thunk
#define flash_utils_ByteArray_position_get_thunk  shell_toplevel_u2a_o_thunk

extern AvmBox shell_toplevel_v2a_ouu_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_remove_thunk  shell_toplevel_v2a_ouu_thunk

extern AvmBox shell_toplevel_i2a_o_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_readInt_thunk  shell_toplevel_i2a_o_thunk
#define flash_utils_ByteArray_readShort_thunk  shell_toplevel_i2a_o_thunk
#define flash_utils_ByteArray_readByte_thunk  shell_toplevel_i2a_o_thunk

extern AvmBox shell_toplevel_v2a_oua_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_insert_thunk  shell_toplevel_v2a_oua_thunk

extern AvmBox shell_toplevel_s2a_oa_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_Domain_getClassName_thunk  shell_toplevel_s2a_oa_thunk

extern AvmBox shell_toplevel_v2a_ouus_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_replace_thunk  shell_toplevel_v2a_ouus_thunk

extern AvmBox shell_toplevel_i2a_os_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_System_exec_thunk  shell_toplevel_i2a_os_thunk

extern AvmBox shell_toplevel_b2a_oa_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_System_isGlobal_thunk  shell_toplevel_b2a_oa_thunk

extern AvmBox shell_toplevel_s2a_os_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_File_read_thunk  shell_toplevel_s2a_os_thunk

extern AvmBox shell_toplevel_s2a_ou_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_readUTFBytes_thunk  shell_toplevel_s2a_ou_thunk
#define avmplus_StringBuilder_charAt_thunk  shell_toplevel_s2a_ou_thunk

extern AvmBox shell_toplevel_b2a_oi_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_net_Socket_listen_thunk  shell_toplevel_b2a_oi_thunk

extern AvmBox shell_toplevel_b2a_os_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_File_exists_thunk  shell_toplevel_b2a_os_thunk

extern AvmBox shell_toplevel_a2a_o_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_sampler_getSamples_thunk  shell_toplevel_a2a_o_thunk
#define avmplus_Domain_currentDomain_get_thunk  shell_toplevel_a2a_o_thunk
#define avmplus_System_private_getArgv_thunk  shell_toplevel_a2a_o_thunk
#define flash_net_Socket_accept_thunk  shell_toplevel_a2a_o_thunk
#define flash_trace_Trace_getListener_thunk  shell_toplevel_a2a_o_thunk
#define flash_sampler_NewObjectSample_object_get_thunk  shell_toplevel_a2a_o_thunk
#define avmplus_Domain_domainMemory_get_thunk  shell_toplevel_a2a_o_thunk

extern double shell_toplevel_d2d_oaou_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_sampler__getInvocationCount_thunk  shell_toplevel_d2d_oaou_thunk

extern AvmBox shell_toplevel_i2a_oo_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_net_Socket_private_nb_write_thunk  shell_toplevel_i2a_oo_thunk
#define flash_net_Socket_private_nb_read_thunk  shell_toplevel_i2a_oo_thunk

extern AvmBox shell_toplevel_i2a_osu_optu4294967295U_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_lastIndexOf_thunk  shell_toplevel_i2a_osu_optu4294967295U_thunk

extern AvmBox shell_toplevel_v2a_od_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_writeDouble_thunk  shell_toplevel_v2a_od_thunk
#define flash_utils_ByteArray_writeFloat_thunk  shell_toplevel_v2a_od_thunk

extern AvmBox shell_toplevel_s2a_ouu_optu4294967295U_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_substring_thunk  shell_toplevel_s2a_ouu_optu4294967295U_thunk

extern AvmBox shell_toplevel_v2a_ob_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_Dictionary_private_init_thunk  shell_toplevel_v2a_ob_thunk
#define flash_utils_ByteArray_writeBoolean_thunk  shell_toplevel_v2a_ob_thunk
#define flash_sampler_sampleInternalAllocs_thunk  shell_toplevel_v2a_ob_thunk

extern AvmBox shell_toplevel_i2a_oi_opti2_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_trace_Trace_getLevel_thunk  shell_toplevel_i2a_oi_opti2_thunk

extern double shell_toplevel_d2d_oa_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_sampler_getSize_thunk  shell_toplevel_d2d_oa_thunk

extern AvmBox shell_toplevel_v2a_oo_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_Domain_private_init_thunk  shell_toplevel_v2a_oo_thunk
#define avmplus_System_trace_thunk  shell_toplevel_v2a_oo_thunk
#define flash_sampler__setSamplerCallback_thunk  shell_toplevel_v2a_oo_thunk
#define avmplus_System_setHeartbeatCallback_thunk  shell_toplevel_v2a_oo_thunk

extern AvmBox shell_toplevel_i2a_osu_opti0_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_StringBuilder_indexOf_thunk  shell_toplevel_i2a_osu_opti0_thunk

extern AvmBox shell_toplevel_v2a_o_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define avmplus_System_debugger_thunk  shell_toplevel_v2a_o_thunk
#define flash_sampler_startSampling_thunk  shell_toplevel_v2a_o_thunk
#define flash_utils_ByteArray_private_zlib_compress_thunk  shell_toplevel_v2a_o_thunk
#define flash_sampler_clearSamples_thunk  shell_toplevel_v2a_o_thunk
#define flash_sampler_pauseSampling_thunk  shell_toplevel_v2a_o_thunk
#define flash_sampler_stopSampling_thunk  shell_toplevel_v2a_o_thunk
#define avmplus_System_ns_example_nstest_thunk  shell_toplevel_v2a_o_thunk
#define avmplus_StringBuilder_trimToSize_thunk  shell_toplevel_v2a_o_thunk
#define flash_net_Socket_private_nb_disconnect_thunk  shell_toplevel_v2a_o_thunk
#define flash_utils_ByteArray_private_zlib_uncompress_thunk  shell_toplevel_v2a_o_thunk
#define avmplus_StringBuilder_reverse_thunk  shell_toplevel_v2a_o_thunk

extern AvmBox shell_toplevel_a2a_oii_opti2_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_trace_Trace_setLevel_thunk  shell_toplevel_a2a_oii_opti2_thunk

extern AvmBox shell_toplevel_b2a_o_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_readBoolean_thunk  shell_toplevel_b2a_o_thunk
#define avmplus_System_isDebugger_thunk  shell_toplevel_b2a_o_thunk
#define flash_net_Socket_hasConnection_thunk  shell_toplevel_b2a_o_thunk

extern AvmBox shell_toplevel_v2a_os_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_writeUTF_thunk  shell_toplevel_v2a_os_thunk
#define flash_utils_ByteArray_endian_set_thunk  shell_toplevel_v2a_os_thunk
#define flash_utils_ByteArray_writeFile_thunk  shell_toplevel_v2a_os_thunk
#define avmplus_System_write_thunk  shell_toplevel_v2a_os_thunk
#define flash_utils_ByteArray_writeUTFBytes_thunk  shell_toplevel_v2a_os_thunk

extern AvmBox shell_toplevel_v2a_oi_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_utils_ByteArray_writeByte_thunk  shell_toplevel_v2a_oi_thunk
#define avmplus_System_exit_thunk  shell_toplevel_v2a_oi_thunk
#define flash_utils_ByteArray_writeInt_thunk  shell_toplevel_v2a_oi_thunk
#define flash_utils_ByteArray_writeShort_thunk  shell_toplevel_v2a_oi_thunk

extern AvmBox shell_toplevel_i2a_osi_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_net_Socket_private_nb_connect_thunk  shell_toplevel_i2a_osi_thunk

extern AvmBox shell_toplevel_a2a_oab_optbfalse_thunk(AvmMethodEnv env, uint32_t argc, AvmBox* argv);
#define flash_sampler_getMemberNames_thunk  shell_toplevel_a2a_oab_optbfalse_thunk

