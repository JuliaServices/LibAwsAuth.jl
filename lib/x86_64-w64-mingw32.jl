using CEnum

"""
    aws_auth_errors

Auth-specific error codes
"""
@cenum aws_auth_errors::UInt32 begin
    AWS_AUTH_PROFILE_PARSE_RECOVERABLE_ERROR = 15362
    AWS_AUTH_PROFILE_PARSE_FATAL_ERROR = 15361
    AWS_AUTH_SIGNING_UNSUPPORTED_ALGORITHM = 6144
    AWS_AUTH_SIGNING_MISMATCHED_CONFIGURATION = 6145
    AWS_AUTH_SIGNING_NO_CREDENTIALS = 6146
    AWS_AUTH_SIGNING_ILLEGAL_REQUEST_QUERY_PARAM = 6147
    AWS_AUTH_SIGNING_ILLEGAL_REQUEST_HEADER = 6148
    AWS_AUTH_SIGNING_INVALID_CONFIGURATION = 6149
    AWS_AUTH_CREDENTIALS_PROVIDER_INVALID_ENVIRONMENT = 6150
    AWS_AUTH_CREDENTIALS_PROVIDER_INVALID_DELEGATE = 6151
    AWS_AUTH_CREDENTIALS_PROVIDER_PROFILE_SOURCE_FAILURE = 6152
    AWS_AUTH_CREDENTIALS_PROVIDER_IMDS_SOURCE_FAILURE = 6153
    AWS_AUTH_CREDENTIALS_PROVIDER_STS_SOURCE_FAILURE = 6154
    AWS_AUTH_CREDENTIALS_PROVIDER_HTTP_STATUS_FAILURE = 6155
    AWS_AUTH_PROVIDER_PARSER_UNEXPECTED_RESPONSE = 6156
    AWS_AUTH_CREDENTIALS_PROVIDER_ECS_SOURCE_FAILURE = 6157
    AWS_AUTH_CREDENTIALS_PROVIDER_X509_SOURCE_FAILURE = 6158
    AWS_AUTH_CREDENTIALS_PROVIDER_PROCESS_SOURCE_FAILURE = 6159
    AWS_AUTH_CREDENTIALS_PROVIDER_STS_WEB_IDENTITY_SOURCE_FAILURE = 6160
    AWS_AUTH_SIGNING_UNSUPPORTED_SIGNATURE_TYPE = 6161
    AWS_AUTH_SIGNING_MISSING_PREVIOUS_SIGNATURE = 6162
    AWS_AUTH_SIGNING_INVALID_CREDENTIALS = 6163
    AWS_AUTH_CANONICAL_REQUEST_MISMATCH = 6164
    AWS_AUTH_SIGV4A_SIGNATURE_VALIDATION_FAILURE = 6165
    AWS_AUTH_CREDENTIALS_PROVIDER_COGNITO_SOURCE_FAILURE = 6166
    AWS_AUTH_CREDENTIALS_PROVIDER_DELEGATE_FAILURE = 6167
    AWS_AUTH_SSO_TOKEN_PROVIDER_SOURCE_FAILURE = 6168
    AWS_AUTH_SSO_TOKEN_INVALID = 6169
    AWS_AUTH_SSO_TOKEN_EXPIRED = 6170
    AWS_AUTH_CREDENTIALS_PROVIDER_SSO_SOURCE_FAILURE = 6171
    AWS_AUTH_ERROR_END_RANGE = 7167
end

"""
    aws_auth_log_subject

Auth-specific logging subjects
"""
@cenum aws_auth_log_subject::UInt32 begin
    AWS_LS_AUTH_GENERAL = 6144
    AWS_LS_AUTH_PROFILE = 6145
    AWS_LS_AUTH_CREDENTIALS_PROVIDER = 6146
    AWS_LS_AUTH_SIGNING = 6147
    AWS_LS_IMDS_CLIENT = 6148
    AWS_LS_AUTH_LAST = 7167
end

"""
    aws_auth_library_init(allocator)

Initializes internal datastructures used by aws-c-auth. Must be called before using any functionality in aws-c-auth.

# Arguments
* `allocator`: memory allocator to use for any module-level memory allocation
### Prototype
```c
void aws_auth_library_init(struct aws_allocator *allocator);
```
"""
function aws_auth_library_init(allocator)
    ccall((:aws_auth_library_init, libaws_c_auth), Cvoid, (Ptr{aws_allocator},), allocator)
end

"""
    aws_auth_library_clean_up()

Clean up internal datastructures used by aws-c-auth. Must not be called until application is done using functionality in aws-c-auth.

### Prototype
```c
void aws_auth_library_clean_up(void);
```
"""
function aws_auth_library_clean_up()
    ccall((:aws_auth_library_clean_up, libaws_c_auth), Cvoid, ())
end

# typedef void ( aws_imds_client_shutdown_completed_fn ) ( void * user_data )
"""
Documentation not found.
"""
const aws_imds_client_shutdown_completed_fn = Cvoid

"""
    aws_imds_client_shutdown_options

Optional callback and user data to be invoked when an imds client has fully shut down
"""
struct aws_imds_client_shutdown_options
    shutdown_callback::Ptr{aws_imds_client_shutdown_completed_fn}
    shutdown_user_data::Ptr{Cvoid}
end

"""
    aws_imds_protocol_version

Documentation not found.
"""
@cenum aws_imds_protocol_version::UInt32 begin
    IMDS_PROTOCOL_V2 = 0
    IMDS_PROTOCOL_V1 = 1
end

"""
Documentation not found.
"""
mutable struct aws_auth_http_system_vtable end

"""
    aws_imds_client_options

Configuration options when creating an imds client
"""
struct aws_imds_client_options
    shutdown_options::aws_imds_client_shutdown_options
    bootstrap::Ptr{aws_client_bootstrap}
    retry_strategy::Ptr{aws_retry_strategy}
    imds_version::aws_imds_protocol_version
    function_table::Ptr{aws_auth_http_system_vtable}
end

# typedef void ( aws_imds_client_on_get_resource_callback_fn ) ( const struct aws_byte_buf * resource , int error_code , void * user_data )
"""
Documentation not found.
"""
const aws_imds_client_on_get_resource_callback_fn = Cvoid

"""
    aws_imds_iam_profile

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-categories.html
"""
struct aws_imds_iam_profile
    data::NTuple{128, UInt8}
end

function Base.getproperty(x::Ptr{aws_imds_iam_profile}, f::Symbol)
    f === :last_updated && return Ptr{aws_date_time}(x + 0)
    f === :instance_profile_arn && return Ptr{aws_byte_cursor}(x + 96)
    f === :instance_profile_id && return Ptr{aws_byte_cursor}(x + 112)
    return getfield(x, f)
end

function Base.getproperty(x::aws_imds_iam_profile, f::Symbol)
    r = Ref{aws_imds_iam_profile}(x)
    ptr = Base.unsafe_convert(Ptr{aws_imds_iam_profile}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{aws_imds_iam_profile}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

"""
    aws_imds_instance_info

Block of per-instance EC2-specific data

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
"""
struct aws_imds_instance_info
    data::NTuple{352, UInt8}
end

function Base.getproperty(x::Ptr{aws_imds_instance_info}, f::Symbol)
    f === :marketplace_product_codes && return Ptr{aws_array_list}(x + 0)
    f === :availability_zone && return Ptr{aws_byte_cursor}(x + 40)
    f === :private_ip && return Ptr{aws_byte_cursor}(x + 56)
    f === :version && return Ptr{aws_byte_cursor}(x + 72)
    f === :instance_id && return Ptr{aws_byte_cursor}(x + 88)
    f === :billing_products && return Ptr{aws_array_list}(x + 104)
    f === :instance_type && return Ptr{aws_byte_cursor}(x + 144)
    f === :account_id && return Ptr{aws_byte_cursor}(x + 160)
    f === :image_id && return Ptr{aws_byte_cursor}(x + 176)
    f === :pending_time && return Ptr{aws_date_time}(x + 192)
    f === :architecture && return Ptr{aws_byte_cursor}(x + 288)
    f === :kernel_id && return Ptr{aws_byte_cursor}(x + 304)
    f === :ramdisk_id && return Ptr{aws_byte_cursor}(x + 320)
    f === :region && return Ptr{aws_byte_cursor}(x + 336)
    return getfield(x, f)
end

function Base.getproperty(x::aws_imds_instance_info, f::Symbol)
    r = Ref{aws_imds_instance_info}(x)
    ptr = Base.unsafe_convert(Ptr{aws_imds_instance_info}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{aws_imds_instance_info}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

# typedef void ( aws_imds_client_on_get_array_callback_fn ) ( const struct aws_array_list * array , int error_code , void * user_data )
"""
Documentation not found.
"""
const aws_imds_client_on_get_array_callback_fn = Cvoid

# typedef void ( aws_imds_client_on_get_credentials_callback_fn ) ( const struct aws_credentials * credentials , int error_code , void * user_data )
"""
Documentation not found.
"""
const aws_imds_client_on_get_credentials_callback_fn = Cvoid

# typedef void ( aws_imds_client_on_get_iam_profile_callback_fn ) ( const struct aws_imds_iam_profile * iam_profile_info , int error_code , void * user_data )
"""
Documentation not found.
"""
const aws_imds_client_on_get_iam_profile_callback_fn = Cvoid

# typedef void ( aws_imds_client_on_get_instance_info_callback_fn ) ( const struct aws_imds_instance_info * instance_info , int error_code , void * user_data )
"""
Documentation not found.
"""
const aws_imds_client_on_get_instance_info_callback_fn = Cvoid

"""
AWS EC2 Metadata Client is used to retrieve AWS EC2 Instance Metadata info.
"""
mutable struct aws_imds_client end

"""
    aws_imds_client_new(allocator, options)

Creates a new imds client

# Arguments
* `allocator`: memory allocator to use for creation and queries
* `options`: configuration options for the imds client
# Returns
a newly-constructed imds client, or NULL on failure
### Prototype
```c
struct aws_imds_client *aws_imds_client_new( struct aws_allocator *allocator, const struct aws_imds_client_options *options);
```
"""
function aws_imds_client_new(allocator, options)
    ccall((:aws_imds_client_new, libaws_c_auth), Ptr{aws_imds_client}, (Ptr{aws_allocator}, Ptr{aws_imds_client_options}), allocator, options)
end

"""
    aws_imds_client_acquire(client)

Increments the ref count on the client

# Arguments
* `client`: imds client to acquire a reference to
### Prototype
```c
void aws_imds_client_acquire(struct aws_imds_client *client);
```
"""
function aws_imds_client_acquire(client)
    ccall((:aws_imds_client_acquire, libaws_c_auth), Cvoid, (Ptr{aws_imds_client},), client)
end

"""
    aws_imds_client_release(client)

Decrements the ref count on the client

# Arguments
* `client`: imds client to release a reference to
### Prototype
```c
void aws_imds_client_release(struct aws_imds_client *client);
```
"""
function aws_imds_client_release(client)
    ccall((:aws_imds_client_release, libaws_c_auth), Cvoid, (Ptr{aws_imds_client},), client)
end

"""
    aws_imds_client_get_resource_async(client, resource_path, callback, user_data)

Queries a generic resource (string) from the ec2 instance metadata document

# Arguments
* `client`: imds client to use for the query
* `resource_path`: path of the resource to query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_resource_async( struct aws_imds_client *client, struct aws_byte_cursor resource_path, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_resource_async(client, resource_path, callback, user_data)
    ccall((:aws_imds_client_get_resource_async, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_byte_cursor, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, resource_path, callback, user_data)
end

"""
    aws_imds_client_get_ami_id(client, callback, user_data)

Gets the ami id of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_ami_id( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_ami_id(client, callback, user_data)
    ccall((:aws_imds_client_get_ami_id, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_ami_launch_index(client, callback, user_data)

Gets the ami launch index of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_ami_launch_index( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_ami_launch_index(client, callback, user_data)
    ccall((:aws_imds_client_get_ami_launch_index, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_ami_manifest_path(client, callback, user_data)

Gets the ami manifest path of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_ami_manifest_path( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_ami_manifest_path(client, callback, user_data)
    ccall((:aws_imds_client_get_ami_manifest_path, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_ancestor_ami_ids(client, callback, user_data)

Gets the list of ancestor ami ids of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_ancestor_ami_ids( struct aws_imds_client *client, aws_imds_client_on_get_array_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_ancestor_ami_ids(client, callback, user_data)
    ccall((:aws_imds_client_get_ancestor_ami_ids, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_array_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_instance_action(client, callback, user_data)

Gets the instance-action of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_instance_action( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_instance_action(client, callback, user_data)
    ccall((:aws_imds_client_get_instance_action, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_instance_id(client, callback, user_data)

Gets the instance id of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_instance_id( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_instance_id(client, callback, user_data)
    ccall((:aws_imds_client_get_instance_id, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_instance_type(client, callback, user_data)

Gets the instance type of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_instance_type( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_instance_type(client, callback, user_data)
    ccall((:aws_imds_client_get_instance_type, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_mac_address(client, callback, user_data)

Gets the mac address of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_mac_address( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_mac_address(client, callback, user_data)
    ccall((:aws_imds_client_get_mac_address, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_private_ip_address(client, callback, user_data)

Gets the private ip address of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_private_ip_address( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_private_ip_address(client, callback, user_data)
    ccall((:aws_imds_client_get_private_ip_address, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_availability_zone(client, callback, user_data)

Gets the availability zone of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_availability_zone( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_availability_zone(client, callback, user_data)
    ccall((:aws_imds_client_get_availability_zone, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_product_codes(client, callback, user_data)

Gets the product codes of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_product_codes( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_product_codes(client, callback, user_data)
    ccall((:aws_imds_client_get_product_codes, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_public_key(client, callback, user_data)

Gets the public key of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_public_key( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_public_key(client, callback, user_data)
    ccall((:aws_imds_client_get_public_key, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_ramdisk_id(client, callback, user_data)

Gets the ramdisk id of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_ramdisk_id( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_ramdisk_id(client, callback, user_data)
    ccall((:aws_imds_client_get_ramdisk_id, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_reservation_id(client, callback, user_data)

Gets the reservation id of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_reservation_id( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_reservation_id(client, callback, user_data)
    ccall((:aws_imds_client_get_reservation_id, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_security_groups(client, callback, user_data)

Gets the list of the security groups of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_security_groups( struct aws_imds_client *client, aws_imds_client_on_get_array_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_security_groups(client, callback, user_data)
    ccall((:aws_imds_client_get_security_groups, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_array_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_block_device_mapping(client, callback, user_data)

Gets the list of block device mappings of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_block_device_mapping( struct aws_imds_client *client, aws_imds_client_on_get_array_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_block_device_mapping(client, callback, user_data)
    ccall((:aws_imds_client_get_block_device_mapping, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_array_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_attached_iam_role(client, callback, user_data)

Gets the attached iam role of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_attached_iam_role( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_attached_iam_role(client, callback, user_data)
    ccall((:aws_imds_client_get_attached_iam_role, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_credentials(client, iam_role_name, callback, user_data)

Gets temporary credentials based on the attached iam role of the ec2 instance

# Arguments
* `client`: imds client to use for the query
* `iam_role_name`: iam role name to get temporary credentials through
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_credentials( struct aws_imds_client *client, struct aws_byte_cursor iam_role_name, aws_imds_client_on_get_credentials_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_credentials(client, iam_role_name, callback, user_data)
    ccall((:aws_imds_client_get_credentials, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_byte_cursor, aws_imds_client_on_get_credentials_callback_fn, Ptr{Cvoid}), client, iam_role_name, callback, user_data)
end

"""
    aws_imds_client_get_iam_profile(client, callback, user_data)

Gets the iam profile information of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_iam_profile( struct aws_imds_client *client, aws_imds_client_on_get_iam_profile_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_iam_profile(client, callback, user_data)
    ccall((:aws_imds_client_get_iam_profile, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_iam_profile_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_user_data(client, callback, user_data)

Gets the user data of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_user_data( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_user_data(client, callback, user_data)
    ccall((:aws_imds_client_get_user_data, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_instance_signature(client, callback, user_data)

Gets the signature of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_instance_signature( struct aws_imds_client *client, aws_imds_client_on_get_resource_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_instance_signature(client, callback, user_data)
    ccall((:aws_imds_client_get_instance_signature, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_resource_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
    aws_imds_client_get_instance_info(client, callback, user_data)

Gets the instance information data block of the ec2 instance from the instance metadata document

# Arguments
* `client`: imds client to use for the query
* `callback`: callback function to invoke on query success or failure
* `user_data`: opaque data to invoke the completion callback with
# Returns
AWS\\_OP\\_SUCCESS if the query was successfully started, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_imds_client_get_instance_info( struct aws_imds_client *client, aws_imds_client_on_get_instance_info_callback_fn callback, void *user_data);
```
"""
function aws_imds_client_get_instance_info(client, callback, user_data)
    ccall((:aws_imds_client_get_instance_info, libaws_c_auth), Cint, (Ptr{aws_imds_client}, aws_imds_client_on_get_instance_info_callback_fn, Ptr{Cvoid}), client, callback, user_data)
end

"""
Documentation not found.
"""
mutable struct aws_ecc_key_pair end

# typedef void ( aws_on_get_credentials_callback_fn ) ( struct aws_credentials * credentials , int error_code , void * user_data )
"""
Documentation not found.
"""
const aws_on_get_credentials_callback_fn = Cvoid

# typedef int ( aws_credentials_provider_get_credentials_fn ) ( struct aws_credentials_provider * provider , aws_on_get_credentials_callback_fn callback , void * user_data )
"""
Documentation not found.
"""
const aws_credentials_provider_get_credentials_fn = Cvoid

# typedef void ( aws_credentials_provider_destroy_fn ) ( struct aws_credentials_provider * provider )
"""
Documentation not found.
"""
const aws_credentials_provider_destroy_fn = Cvoid

"""
    aws_credentials_provider_vtable

Documentation not found.
"""
struct aws_credentials_provider_vtable
    get_credentials::Ptr{aws_credentials_provider_get_credentials_fn}
    destroy::Ptr{aws_credentials_provider_destroy_fn}
end

# typedef void ( aws_credentials_provider_shutdown_completed_fn ) ( void * user_data )
"""
Documentation not found.
"""
const aws_credentials_provider_shutdown_completed_fn = Cvoid

"""
    aws_credentials_provider_shutdown_options

Documentation not found.
"""
struct aws_credentials_provider_shutdown_options
    shutdown_callback::Ptr{aws_credentials_provider_shutdown_completed_fn}
    shutdown_user_data::Ptr{Cvoid}
end

"""
    aws_credentials_provider

A baseclass for credentials providers. A credentials provider is an object that has an asynchronous query function for retrieving AWS credentials.

Ref-counted. Thread-safe.
"""
struct aws_credentials_provider
    vtable::Ptr{aws_credentials_provider_vtable}
    allocator::Ptr{aws_allocator}
    shutdown_options::aws_credentials_provider_shutdown_options
    impl::Ptr{Cvoid}
    ref_count::aws_atomic_var
end

"""
    aws_credentials_provider_static_options

Configuration options for a provider that returns a fixed set of credentials
"""
struct aws_credentials_provider_static_options
    shutdown_options::aws_credentials_provider_shutdown_options
    access_key_id::aws_byte_cursor
    secret_access_key::aws_byte_cursor
    session_token::aws_byte_cursor
end

"""
    aws_credentials_provider_environment_options

Configuration options for a provider that returns credentials based on environment variable values
"""
struct aws_credentials_provider_environment_options
    shutdown_options::aws_credentials_provider_shutdown_options
end

"""
Documentation not found.
"""
mutable struct aws_profile_collection end

"""
Documentation not found.
"""
mutable struct aws_tls_ctx end

"""
    aws_credentials_provider_profile_options

Configuration options for a provider that sources credentials from the aws config and credentials files (by default ~/.aws/config and ~/.aws/credentials)
"""
struct aws_credentials_provider_profile_options
    shutdown_options::aws_credentials_provider_shutdown_options
    profile_name_override::aws_byte_cursor
    config_file_name_override::aws_byte_cursor
    credentials_file_name_override::aws_byte_cursor
    profile_collection_cached::Ptr{aws_profile_collection}
    bootstrap::Ptr{aws_client_bootstrap}
    tls_ctx::Ptr{aws_tls_ctx}
    function_table::Ptr{aws_auth_http_system_vtable}
end

"""
    aws_credentials_provider_cached_options

Configuration options for a provider that functions as a caching decorator. Credentials sourced through this provider will be cached within it until their expiration time. When the cached credentials expire, new credentials will be fetched when next queried.
"""
struct aws_credentials_provider_cached_options
    shutdown_options::aws_credentials_provider_shutdown_options
    source::Ptr{aws_credentials_provider}
    refresh_time_in_milliseconds::UInt64
    high_res_clock_fn::Ptr{aws_io_clock_fn}
    system_clock_fn::Ptr{aws_io_clock_fn}
end

"""
    aws_credentials_provider_chain_options

Configuration options for a provider that queries, in order, a list of providers. This provider uses the first set of credentials successfully queried. Providers are queried one at a time; a provider is not queried until the preceding provider has failed to source credentials.
"""
struct aws_credentials_provider_chain_options
    shutdown_options::aws_credentials_provider_shutdown_options
    providers::Ptr{Ptr{aws_credentials_provider}}
    provider_count::Csize_t
end

"""
    aws_credentials_provider_imds_options

Configuration options for the provider that sources credentials from ec2 instance metadata
"""
struct aws_credentials_provider_imds_options
    shutdown_options::aws_credentials_provider_shutdown_options
    bootstrap::Ptr{aws_client_bootstrap}
    imds_version::aws_imds_protocol_version
    function_table::Ptr{aws_auth_http_system_vtable}
end

"""
    aws_credentials_provider_ecs_options

Documentation not found.
"""
struct aws_credentials_provider_ecs_options
    shutdown_options::aws_credentials_provider_shutdown_options
    bootstrap::Ptr{aws_client_bootstrap}
    host::aws_byte_cursor
    path_and_query::aws_byte_cursor
    auth_token::aws_byte_cursor
    tls_ctx::Ptr{aws_tls_ctx}
    function_table::Ptr{aws_auth_http_system_vtable}
    port::UInt16
end

"""
Documentation not found.
"""
mutable struct aws_http_proxy_options end

"""
    aws_credentials_provider_x509_options

Configuration options for the X509 credentials provider

The x509 credentials provider sources temporary credentials from AWS IoT Core using TLS mutual authentication. See details: https://docs.aws.amazon.com/iot/latest/developerguide/authorizing-direct-aws.html An end to end demo with detailed steps can be found here: https://aws.amazon.com/blogs/security/how-to-eliminate-the-need-for-hardcoded-aws-credentials-in-devices-by-using-the-aws-iot-credentials-provider/
"""
struct aws_credentials_provider_x509_options
    shutdown_options::aws_credentials_provider_shutdown_options
    bootstrap::Ptr{aws_client_bootstrap}
    tls_connection_options::Ptr{aws_tls_connection_options}
    thing_name::aws_byte_cursor
    role_alias::aws_byte_cursor
    endpoint::aws_byte_cursor
    proxy_options::Ptr{aws_http_proxy_options}
    function_table::Ptr{aws_auth_http_system_vtable}
end

"""
    aws_credentials_provider_sts_web_identity_options

Configuration options for the STS web identity provider

Sts with web identity credentials provider sources a set of temporary security credentials for users who have been authenticated in a mobile or web application with a web identity provider. Example providers include Amazon Cognito, Login with Amazon, Facebook, Google, or any OpenID Connect-compatible identity provider like Elastic Kubernetes Service https://docs.aws.amazon.com/STS/latest/APIReference/API\\_AssumeRoleWithWebIdentity.html The required parameters used in the request (region, roleArn, sessionName, tokenFilePath) are automatically resolved by SDK from envrionment variables or config file. --------------------------------------------------------------------------------- | Parameter | Environment Variable Name | Config File Property Name | ---------------------------------------------------------------------------------- | region | AWS\\_DEFAULT\\_REGION | region | | role\\_arn | AWS\\_ROLE\\_ARN | role\\_arn | | role\\_session\\_name | AWS\\_ROLE\\_SESSION\\_NAME | role\\_session\\_name | | token\\_file\\_path | AWS\\_WEB\\_IDENTITY\\_TOKEN\\_FILE | web\\_identity\\_token\\_file | |--------------------------------------------------------------------------------|
"""
struct aws_credentials_provider_sts_web_identity_options
    shutdown_options::aws_credentials_provider_shutdown_options
    bootstrap::Ptr{aws_client_bootstrap}
    config_profile_collection_cached::Ptr{aws_profile_collection}
    tls_ctx::Ptr{aws_tls_ctx}
    function_table::Ptr{aws_auth_http_system_vtable}
    profile_name_override::aws_byte_cursor
end

"""
    aws_credentials_provider_sso_options

Documentation not found.
"""
struct aws_credentials_provider_sso_options
    shutdown_options::aws_credentials_provider_shutdown_options
    profile_name_override::aws_byte_cursor
    config_file_name_override::aws_byte_cursor
    config_file_cached::Ptr{aws_profile_collection}
    bootstrap::Ptr{aws_client_bootstrap}
    tls_ctx::Ptr{aws_tls_ctx}
    function_table::Ptr{aws_auth_http_system_vtable}
    system_clock_fn::Ptr{aws_io_clock_fn}
end

"""
    aws_credentials_provider_sts_options

Configuration options for the STS credentials provider
"""
struct aws_credentials_provider_sts_options
    bootstrap::Ptr{aws_client_bootstrap}
    tls_ctx::Ptr{aws_tls_ctx}
    creds_provider::Ptr{aws_credentials_provider}
    role_arn::aws_byte_cursor
    session_name::aws_byte_cursor
    duration_seconds::UInt16
    http_proxy_options::Ptr{aws_http_proxy_options}
    shutdown_options::aws_credentials_provider_shutdown_options
    function_table::Ptr{aws_auth_http_system_vtable}
    system_clock_fn::Ptr{aws_io_clock_fn}
end

"""
    aws_credentials_provider_process_options

Configuration options for the process credentials provider

The process credentials provider sources credentials from running a command or process. The command to run is sourced from a profile in the AWS config file, using the standard profile selection rules. The profile key the command is read from is "credential\\_process." E.g.: [default] credential\\_process=/opt/amazon/bin/my-credential-fetcher --argsA=abc On successfully running the command, the output should be a json data with the following format: { "Version": 1, "AccessKeyId": "accesskey", "SecretAccessKey": "secretAccessKey" "SessionToken": "....", "Expiration": "2019-05-29T00:21:43Z" } Version here identifies the command output format version.
"""
struct aws_credentials_provider_process_options
    shutdown_options::aws_credentials_provider_shutdown_options
    profile_to_use::aws_byte_cursor
    config_profile_collection_cached::Ptr{aws_profile_collection}
end

"""
    aws_credentials_provider_chain_default_options

Configuration options for the default credentials provider chain.
"""
struct aws_credentials_provider_chain_default_options
    shutdown_options::aws_credentials_provider_shutdown_options
    bootstrap::Ptr{aws_client_bootstrap}
    tls_ctx::Ptr{aws_tls_ctx}
    profile_collection_cached::Ptr{aws_profile_collection}
    profile_name_override::aws_byte_cursor
end

# typedef int ( aws_credentials_provider_delegate_get_credentials_fn ) ( void * delegate_user_data , aws_on_get_credentials_callback_fn callback , void * callback_user_data )
"""
Documentation not found.
"""
const aws_credentials_provider_delegate_get_credentials_fn = Cvoid

"""
    aws_credentials_provider_delegate_options

Configuration options for the delegate credentials provider.
"""
struct aws_credentials_provider_delegate_options
    shutdown_options::aws_credentials_provider_shutdown_options
    get_credentials::Ptr{aws_credentials_provider_delegate_get_credentials_fn}
    delegate_user_data::Ptr{Cvoid}
end

"""
    aws_cognito_identity_provider_token_pair

A (string) pair defining an identity provider and a valid login token sourced from it.
"""
struct aws_cognito_identity_provider_token_pair
    identity_provider_name::aws_byte_cursor
    identity_provider_token::aws_byte_cursor
end

"""
    aws_credentials_provider_cognito_options

Configuration options needed to create a Cognito-based Credentials Provider
"""
struct aws_credentials_provider_cognito_options
    shutdown_options::aws_credentials_provider_shutdown_options
    endpoint::aws_byte_cursor
    identity::aws_byte_cursor
    logins::Ptr{aws_cognito_identity_provider_token_pair}
    login_count::Csize_t
    custom_role_arn::Ptr{aws_byte_cursor}
    bootstrap::Ptr{aws_client_bootstrap}
    tls_ctx::Ptr{aws_tls_ctx}
    http_proxy_options::Ptr{aws_http_proxy_options}
    function_table::Ptr{aws_auth_http_system_vtable}
end

"""
Documentation not found.
"""
mutable struct aws_credentials end

"""
    aws_credentials_new(allocator, access_key_id_cursor, secret_access_key_cursor, session_token_cursor, expiration_timepoint_seconds)

Creates a new set of aws credentials

# Arguments
* `allocator`: memory allocator to use
* `access_key_id_cursor`: value for the aws access key id field
* `secret_access_key_cursor`: value for the secret access key field
* `session_token_cursor`: (optional) security token associated with the credentials
* `expiration_timepoint_seconds`: timepoint, in seconds since epoch, that the credentials will no longer be valid past. For credentials that do not expire, use UINT64\\_MAX
# Returns
a valid credentials object, or NULL
### Prototype
```c
struct aws_credentials *aws_credentials_new( struct aws_allocator *allocator, struct aws_byte_cursor access_key_id_cursor, struct aws_byte_cursor secret_access_key_cursor, struct aws_byte_cursor session_token_cursor, uint64_t expiration_timepoint_seconds);
```
"""
function aws_credentials_new(allocator, access_key_id_cursor, secret_access_key_cursor, session_token_cursor, expiration_timepoint_seconds)
    ccall((:aws_credentials_new, libaws_c_auth), Ptr{aws_credentials}, (Ptr{aws_allocator}, aws_byte_cursor, aws_byte_cursor, aws_byte_cursor, UInt64), allocator, access_key_id_cursor, secret_access_key_cursor, session_token_cursor, expiration_timepoint_seconds)
end

"""
    aws_credentials_new_anonymous(allocator)

Creates a new set of aws anonymous credentials. Use Anonymous credentials, when you want to skip the signing process.

# Arguments
* `allocator`: memory allocator to use
# Returns
a valid credentials object, or NULL
### Prototype
```c
struct aws_credentials *aws_credentials_new_anonymous(struct aws_allocator *allocator);
```
"""
function aws_credentials_new_anonymous(allocator)
    ccall((:aws_credentials_new_anonymous, libaws_c_auth), Ptr{aws_credentials}, (Ptr{aws_allocator},), allocator)
end

"""
    aws_credentials_new_from_string(allocator, access_key_id, secret_access_key, session_token, expiration_timepoint_seconds)

Creates a new set of AWS credentials

# Arguments
* `allocator`: memory allocator to use
* `access_key_id`: value for the aws access key id field
* `secret_access_key`: value for the secret access key field
* `session_token`: (optional) security token associated with the credentials
* `expiration_timepoint_seconds`: timepoint, in seconds since epoch, that the credentials will no longer be valid past. For credentials that do not expire, use UINT64\\_MAX
# Returns
a valid credentials object, or NULL
### Prototype
```c
struct aws_credentials *aws_credentials_new_from_string( struct aws_allocator *allocator, const struct aws_string *access_key_id, const struct aws_string *secret_access_key, const struct aws_string *session_token, uint64_t expiration_timepoint_seconds);
```
"""
function aws_credentials_new_from_string(allocator, access_key_id, secret_access_key, session_token, expiration_timepoint_seconds)
    ccall((:aws_credentials_new_from_string, libaws_c_auth), Ptr{aws_credentials}, (Ptr{aws_allocator}, Ptr{aws_string}, Ptr{aws_string}, Ptr{aws_string}, UInt64), allocator, access_key_id, secret_access_key, session_token, expiration_timepoint_seconds)
end

"""
    aws_credentials_new_ecc(allocator, access_key_id, ecc_key, session_token, expiration_timepoint_in_seconds)

Creates a set of AWS credentials that includes an ECC key pair. These credentials do not have a value for the secret access key; the ecc key takes over that field's role in sigv4a signing.

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `access_key_id`: access key id for the credential set
* `ecc_key`: ecc key to use during signing when using these credentials
* `session_token`: (optional) session token associated with the credentials
* `expiration_timepoint_in_seconds`: (optional) if session-based, time at which these credentials expire
# Returns
a new pair of AWS credentials, or NULL
### Prototype
```c
struct aws_credentials *aws_credentials_new_ecc( struct aws_allocator *allocator, struct aws_byte_cursor access_key_id, struct aws_ecc_key_pair *ecc_key, struct aws_byte_cursor session_token, uint64_t expiration_timepoint_in_seconds);
```
"""
function aws_credentials_new_ecc(allocator, access_key_id, ecc_key, session_token, expiration_timepoint_in_seconds)
    ccall((:aws_credentials_new_ecc, libaws_c_auth), Ptr{aws_credentials}, (Ptr{aws_allocator}, aws_byte_cursor, Ptr{aws_ecc_key_pair}, aws_byte_cursor, UInt64), allocator, access_key_id, ecc_key, session_token, expiration_timepoint_in_seconds)
end

"""
    aws_credentials_new_ecc_from_aws_credentials(allocator, credentials)

Documentation not found.
### Prototype
```c
struct aws_credentials *aws_credentials_new_ecc_from_aws_credentials( struct aws_allocator *allocator, const struct aws_credentials *credentials);
```
"""
function aws_credentials_new_ecc_from_aws_credentials(allocator, credentials)
    ccall((:aws_credentials_new_ecc_from_aws_credentials, libaws_c_auth), Ptr{aws_credentials}, (Ptr{aws_allocator}, Ptr{aws_credentials}), allocator, credentials)
end

"""
    aws_credentials_acquire(credentials)

Add a reference to some credentials

# Arguments
* `credentials`: credentials to increment the ref count on
### Prototype
```c
void aws_credentials_acquire(const struct aws_credentials *credentials);
```
"""
function aws_credentials_acquire(credentials)
    ccall((:aws_credentials_acquire, libaws_c_auth), Cvoid, (Ptr{aws_credentials},), credentials)
end

"""
    aws_credentials_release(credentials)

Remove a reference to some credentials

# Arguments
* `credentials`: credentials to decrement the ref count on
### Prototype
```c
void aws_credentials_release(const struct aws_credentials *credentials);
```
"""
function aws_credentials_release(credentials)
    ccall((:aws_credentials_release, libaws_c_auth), Cvoid, (Ptr{aws_credentials},), credentials)
end

"""
    aws_credentials_get_access_key_id(credentials)

Get the AWS access key id from a set of credentials

# Arguments
* `credentials`: credentials to get the access key id from
# Returns
a byte cursor to the access key id
### Prototype
```c
struct aws_byte_cursor aws_credentials_get_access_key_id(const struct aws_credentials *credentials);
```
"""
function aws_credentials_get_access_key_id(credentials)
    ccall((:aws_credentials_get_access_key_id, libaws_c_auth), aws_byte_cursor, (Ptr{aws_credentials},), credentials)
end

"""
    aws_credentials_get_secret_access_key(credentials)

Get the AWS secret access key from a set of credentials

# Arguments
* `credentials`: credentials to get the secret access key from
# Returns
a byte cursor to the secret access key
### Prototype
```c
struct aws_byte_cursor aws_credentials_get_secret_access_key(const struct aws_credentials *credentials);
```
"""
function aws_credentials_get_secret_access_key(credentials)
    ccall((:aws_credentials_get_secret_access_key, libaws_c_auth), aws_byte_cursor, (Ptr{aws_credentials},), credentials)
end

"""
    aws_credentials_get_session_token(credentials)

Get the AWS session token from a set of credentials

# Arguments
* `credentials`: credentials to get the session token from
# Returns
a byte cursor to the session token or an empty byte cursor if there is no session token
### Prototype
```c
struct aws_byte_cursor aws_credentials_get_session_token(const struct aws_credentials *credentials);
```
"""
function aws_credentials_get_session_token(credentials)
    ccall((:aws_credentials_get_session_token, libaws_c_auth), aws_byte_cursor, (Ptr{aws_credentials},), credentials)
end

"""
    aws_credentials_get_expiration_timepoint_seconds(credentials)

Get the expiration timepoint (in seconds since epoch) associated with a set of credentials

# Arguments
* `credentials`: credentials to get the expiration timepoint for
# Returns
the time, in seconds since epoch, the credentials will expire; UINT64\\_MAX for credentials without a specific expiration time
### Prototype
```c
uint64_t aws_credentials_get_expiration_timepoint_seconds(const struct aws_credentials *credentials);
```
"""
function aws_credentials_get_expiration_timepoint_seconds(credentials)
    ccall((:aws_credentials_get_expiration_timepoint_seconds, libaws_c_auth), UInt64, (Ptr{aws_credentials},), credentials)
end

"""
    aws_credentials_get_ecc_key_pair(credentials)

Get the elliptic curve key associated with this set of credentials

# Arguments
* `credentials`: credentials to get the the elliptic curve key for
# Returns
the elliptic curve key associated with the credentials, or NULL if no key is associated with these credentials
### Prototype
```c
struct aws_ecc_key_pair *aws_credentials_get_ecc_key_pair(const struct aws_credentials *credentials);
```
"""
function aws_credentials_get_ecc_key_pair(credentials)
    ccall((:aws_credentials_get_ecc_key_pair, libaws_c_auth), Ptr{aws_ecc_key_pair}, (Ptr{aws_credentials},), credentials)
end

"""
    aws_credentials_is_anonymous(credentials)

If credentials are anonymous, then the signing process is skipped.

# Arguments
* `credentials`: credentials to check
# Returns
true if the credentials are anonymous; false otherwise.
### Prototype
```c
bool aws_credentials_is_anonymous(const struct aws_credentials *credentials);
```
"""
function aws_credentials_is_anonymous(credentials)
    ccall((:aws_credentials_is_anonymous, libaws_c_auth), Bool, (Ptr{aws_credentials},), credentials)
end

"""
    aws_ecc_key_pair_new_ecdsa_p256_key_from_aws_credentials(allocator, credentials)

Derives an ecc key pair (based on the nist P256 curve) from the access key id and secret access key components of a set of AWS credentials using an internal key derivation specification. Used to perform sigv4a signing in the hybrid mode based on AWS credentials.

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `credentials`: AWS credentials to derive the ECC key from using the AWS sigv4a key deriviation specification
# Returns
a new ecc key pair or NULL on failure
### Prototype
```c
struct aws_ecc_key_pair *aws_ecc_key_pair_new_ecdsa_p256_key_from_aws_credentials( struct aws_allocator *allocator, const struct aws_credentials *credentials);
```
"""
function aws_ecc_key_pair_new_ecdsa_p256_key_from_aws_credentials(allocator, credentials)
    ccall((:aws_ecc_key_pair_new_ecdsa_p256_key_from_aws_credentials, libaws_c_auth), Ptr{aws_ecc_key_pair}, (Ptr{aws_allocator}, Ptr{aws_credentials}), allocator, credentials)
end

"""
    aws_credentials_provider_release(provider)

Release a reference to a credentials provider

# Arguments
* `provider`: provider to decrement the ref count on
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_release(struct aws_credentials_provider *provider);
```
"""
function aws_credentials_provider_release(provider)
    ccall((:aws_credentials_provider_release, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_credentials_provider},), provider)
end

"""
    aws_credentials_provider_acquire(provider)

Documentation not found.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_acquire(struct aws_credentials_provider *provider);
```
"""
function aws_credentials_provider_acquire(provider)
    ccall((:aws_credentials_provider_acquire, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_credentials_provider},), provider)
end

"""
    aws_credentials_provider_get_credentials(provider, callback, user_data)

Documentation not found.
### Prototype
```c
int aws_credentials_provider_get_credentials( struct aws_credentials_provider *provider, aws_on_get_credentials_callback_fn callback, void *user_data);
```
"""
function aws_credentials_provider_get_credentials(provider, callback, user_data)
    ccall((:aws_credentials_provider_get_credentials, libaws_c_auth), Cint, (Ptr{aws_credentials_provider}, aws_on_get_credentials_callback_fn, Ptr{Cvoid}), provider, callback, user_data)
end

"""
    aws_credentials_provider_new_static(allocator, options)

Creates a simple provider that just returns a fixed set of credentials

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_static( struct aws_allocator *allocator, const struct aws_credentials_provider_static_options *options);
```
"""
function aws_credentials_provider_new_static(allocator, options)
    ccall((:aws_credentials_provider_new_static, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_static_options}), allocator, options)
end

"""
    aws_credentials_provider_new_anonymous(allocator, shutdown_options)

Creates a simple anonymous credentials provider

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `shutdown_options`: an optional shutdown callback that gets invoked when the resources used by the provider are no longer in use.
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_anonymous( struct aws_allocator *allocator, const struct aws_credentials_provider_shutdown_options *shutdown_options);
```
"""
function aws_credentials_provider_new_anonymous(allocator, shutdown_options)
    ccall((:aws_credentials_provider_new_anonymous, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_shutdown_options}), allocator, shutdown_options)
end

"""
    aws_credentials_provider_new_environment(allocator, options)

Creates a provider that returns credentials sourced from the environment variables:

AWS\\_ACCESS\\_KEY\\_ID AWS\\_SECRET\\_ACCESS\\_KEY AWS\\_SESSION\\_TOKEN

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_environment( struct aws_allocator *allocator, const struct aws_credentials_provider_environment_options *options);
```
"""
function aws_credentials_provider_new_environment(allocator, options)
    ccall((:aws_credentials_provider_new_environment, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_environment_options}), allocator, options)
end

"""
    aws_credentials_provider_new_cached(allocator, options)

Creates a provider that functions as a caching decorating of another provider.

For example, the default chain is implemented as:

CachedProvider -> ProviderChain(EnvironmentProvider -> ProfileProvider -> ECS/EC2IMD etc...)

A reference is taken on the target provider

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_cached( struct aws_allocator *allocator, const struct aws_credentials_provider_cached_options *options);
```
"""
function aws_credentials_provider_new_cached(allocator, options)
    ccall((:aws_credentials_provider_new_cached, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_cached_options}), allocator, options)
end

"""
    aws_credentials_provider_new_profile(allocator, options)

Creates a provider that sources credentials from key-value profiles loaded from the aws credentials file ("~/.aws/credentials" by default) and the aws config file ("~/.aws/config" by default)

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_profile( struct aws_allocator *allocator, const struct aws_credentials_provider_profile_options *options);
```
"""
function aws_credentials_provider_new_profile(allocator, options)
    ccall((:aws_credentials_provider_new_profile, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_profile_options}), allocator, options)
end

"""
    aws_credentials_provider_new_sts(allocator, options)

Creates a provider that assumes an IAM role via. STS AssumeRole() API. This provider will fetch new credentials upon each call to [`aws_credentials_provider_get_credentials`](@ref)().

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_sts( struct aws_allocator *allocator, const struct aws_credentials_provider_sts_options *options);
```
"""
function aws_credentials_provider_new_sts(allocator, options)
    ccall((:aws_credentials_provider_new_sts, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_sts_options}), allocator, options)
end

"""
    aws_credentials_provider_new_chain(allocator, options)

Creates a provider that sources credentials from an ordered sequence of providers, with the overall result being from the first provider to return a valid set of credentials

References are taken on all supplied providers

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_chain( struct aws_allocator *allocator, const struct aws_credentials_provider_chain_options *options);
```
"""
function aws_credentials_provider_new_chain(allocator, options)
    ccall((:aws_credentials_provider_new_chain, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_chain_options}), allocator, options)
end

"""
    aws_credentials_provider_new_imds(allocator, options)

Creates a provider that sources credentials from the ec2 instance metadata service

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_imds( struct aws_allocator *allocator, const struct aws_credentials_provider_imds_options *options);
```
"""
function aws_credentials_provider_new_imds(allocator, options)
    ccall((:aws_credentials_provider_new_imds, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_imds_options}), allocator, options)
end

"""
    aws_credentials_provider_new_ecs(allocator, options)

Creates a provider that sources credentials from the ecs role credentials service

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_ecs( struct aws_allocator *allocator, const struct aws_credentials_provider_ecs_options *options);
```
"""
function aws_credentials_provider_new_ecs(allocator, options)
    ccall((:aws_credentials_provider_new_ecs, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_ecs_options}), allocator, options)
end

"""
    aws_credentials_provider_new_x509(allocator, options)

Creates a provider that sources credentials from IoT Core

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_x509( struct aws_allocator *allocator, const struct aws_credentials_provider_x509_options *options);
```
"""
function aws_credentials_provider_new_x509(allocator, options)
    ccall((:aws_credentials_provider_new_x509, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_x509_options}), allocator, options)
end

"""
    aws_credentials_provider_new_sts_web_identity(allocator, options)

Creates a provider that sources credentials from STS using AssumeRoleWithWebIdentity

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_sts_web_identity( struct aws_allocator *allocator, const struct aws_credentials_provider_sts_web_identity_options *options);
```
"""
function aws_credentials_provider_new_sts_web_identity(allocator, options)
    ccall((:aws_credentials_provider_new_sts_web_identity, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_sts_web_identity_options}), allocator, options)
end

"""
    aws_credentials_provider_new_sso(allocator, options)

Creates a provider that sources credentials from SSO using a SSOToken.

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_sso( struct aws_allocator *allocator, const struct aws_credentials_provider_sso_options *options);
```
"""
function aws_credentials_provider_new_sso(allocator, options)
    ccall((:aws_credentials_provider_new_sso, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_sso_options}), allocator, options)
end

"""
    aws_credentials_provider_new_process(allocator, options)

Documentation not found.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_process( struct aws_allocator *allocator, const struct aws_credentials_provider_process_options *options);
```
"""
function aws_credentials_provider_new_process(allocator, options)
    ccall((:aws_credentials_provider_new_process, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_process_options}), allocator, options)
end

"""
    aws_credentials_provider_new_delegate(allocator, options)

Create a credentials provider depends on provided vtable to fetch the credentials.

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_delegate( struct aws_allocator *allocator, const struct aws_credentials_provider_delegate_options *options);
```
"""
function aws_credentials_provider_new_delegate(allocator, options)
    ccall((:aws_credentials_provider_new_delegate, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_delegate_options}), allocator, options)
end

"""
    aws_credentials_provider_new_cognito(allocator, options)

Creates a provider that sources credentials from the Cognito-Identity service via an invocation of the GetCredentialsForIdentity API call.

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_cognito( struct aws_allocator *allocator, const struct aws_credentials_provider_cognito_options *options);
```
"""
function aws_credentials_provider_new_cognito(allocator, options)
    ccall((:aws_credentials_provider_new_cognito, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_cognito_options}), allocator, options)
end

"""
    aws_credentials_provider_new_cognito_caching(allocator, options)

Creates a cognito-based provider that has a caching layer wrapped around it

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: cognito-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_cognito_caching( struct aws_allocator *allocator, const struct aws_credentials_provider_cognito_options *options);
```
"""
function aws_credentials_provider_new_cognito_caching(allocator, options)
    ccall((:aws_credentials_provider_new_cognito_caching, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_cognito_options}), allocator, options)
end

"""
    aws_credentials_provider_new_chain_default(allocator, options)

Creates the default provider chain used by most AWS SDKs.

Generally:

(1) Environment (2) Profile (3) STS web identity (4) (conditional, off by default) ECS (5) (conditional, on by default) EC2 Instance Metadata

Support for environmental control of the default provider chain is not yet implemented.

# Arguments
* `allocator`: memory allocator to use for all memory allocation
* `options`: provider-specific configuration options
# Returns
the newly-constructed credentials provider, or NULL if an error occurred.
### Prototype
```c
struct aws_credentials_provider *aws_credentials_provider_new_chain_default( struct aws_allocator *allocator, const struct aws_credentials_provider_chain_default_options *options);
```
"""
function aws_credentials_provider_new_chain_default(allocator, options)
    ccall((:aws_credentials_provider_new_chain_default, libaws_c_auth), Ptr{aws_credentials_provider}, (Ptr{aws_allocator}, Ptr{aws_credentials_provider_chain_default_options}), allocator, options)
end

"""
Documentation not found.
"""
mutable struct aws_http_message end

"""
Documentation not found.
"""
mutable struct aws_http_headers end

"""
Documentation not found.
"""
mutable struct aws_input_stream end

"""
    aws_signable_property_list_pair

Documentation not found.
"""
struct aws_signable_property_list_pair
    name::aws_byte_cursor
    value::aws_byte_cursor
end

# typedef int ( aws_signable_get_property_fn ) ( const struct aws_signable * signable , const struct aws_string * name , struct aws_byte_cursor * out_value )
"""
Documentation not found.
"""
const aws_signable_get_property_fn = Cvoid

# typedef int ( aws_signable_get_property_list_fn ) ( const struct aws_signable * signable , const struct aws_string * name , struct aws_array_list * * out_list )
"""
Documentation not found.
"""
const aws_signable_get_property_list_fn = Cvoid

# typedef int ( aws_signable_get_payload_stream_fn ) ( const struct aws_signable * signable , struct aws_input_stream * * out_input_stream )
"""
Documentation not found.
"""
const aws_signable_get_payload_stream_fn = Cvoid

# typedef void ( aws_signable_destroy_fn ) ( struct aws_signable * signable )
"""
Documentation not found.
"""
const aws_signable_destroy_fn = Cvoid

"""
    aws_signable_vtable

Documentation not found.
"""
struct aws_signable_vtable
    get_property::Ptr{aws_signable_get_property_fn}
    get_property_list::Ptr{aws_signable_get_property_list_fn}
    get_payload_stream::Ptr{aws_signable_get_payload_stream_fn}
    destroy::Ptr{aws_signable_destroy_fn}
end

"""
    aws_signable

Signable is a generic interface for any kind of object that can be cryptographically signed.

Like signing\\_result, the signable interface presents

(1) Properties - A set of key-value pairs (2) Property Lists - A set of named key-value pair lists

as well as

(3) A message payload modeled as a stream

When creating a signable "subclass" the query interface should map to retrieving the properties of the underlying object needed by signing algorithms that can operate on it.

As an example, if a signable implementation wrapped an http request, you would query request elements like method and uri from the property interface, headers would be queried via the property list interface, and the request body would map to the payload stream.

String constants that map to agreed on keys for particular signable types ("METHOD", "URI", "HEADERS", etc...) are exposed in appropriate header files.
"""
struct aws_signable
    allocator::Ptr{aws_allocator}
    impl::Ptr{Cvoid}
    vtable::Ptr{aws_signable_vtable}
end

"""
    aws_signable_destroy(signable)

Cleans up and frees all resources associated with a signable instance

# Arguments
* `signable`: signable object to destroy
### Prototype
```c
void aws_signable_destroy(struct aws_signable *signable);
```
"""
function aws_signable_destroy(signable)
    ccall((:aws_signable_destroy, libaws_c_auth), Cvoid, (Ptr{aws_signable},), signable)
end

"""
    aws_signable_get_property(signable, name, out_value)

Retrieves a property (key-value pair) from a signable. Global property name constants are included below.

# Arguments
* `signable`: signable object to retrieve a property from
* `name`: name of the property to query
* `out_value`: output parameter for the property's value
# Returns
AWS\\_OP\\_SUCCESS if the property was successfully fetched, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_signable_get_property( const struct aws_signable *signable, const struct aws_string *name, struct aws_byte_cursor *out_value);
```
"""
function aws_signable_get_property(signable, name, out_value)
    ccall((:aws_signable_get_property, libaws_c_auth), Cint, (Ptr{aws_signable}, Ptr{aws_string}, Ptr{aws_byte_cursor}), signable, name, out_value)
end

"""
    aws_signable_get_property_list(signable, name, out_property_list)

Retrieves a named property list (list of key-value pairs) from a signable. Global property list name constants are included below.

# Arguments
* `signable`: signable object to retrieve a property list from
* `name`: name of the property list to fetch
* `out_property_list`: output parameter for the fetched property list
# Returns
AWS\\_OP\\_SUCCESS if the property list was successfully fetched, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_signable_get_property_list( const struct aws_signable *signable, const struct aws_string *name, struct aws_array_list **out_property_list);
```
"""
function aws_signable_get_property_list(signable, name, out_property_list)
    ccall((:aws_signable_get_property_list, libaws_c_auth), Cint, (Ptr{aws_signable}, Ptr{aws_string}, Ptr{Ptr{aws_array_list}}), signable, name, out_property_list)
end

"""
    aws_signable_get_payload_stream(signable, out_input_stream)

Retrieves the signable's message payload as a stream.

# Arguments
* `signable`: signable to get the payload of
* `out_input_stream`: output parameter for the payload stream
# Returns
AWS\\_OP\\_SUCCESS if successful, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_signable_get_payload_stream(const struct aws_signable *signable, struct aws_input_stream **out_input_stream);
```
"""
function aws_signable_get_payload_stream(signable, out_input_stream)
    ccall((:aws_signable_get_payload_stream, libaws_c_auth), Cint, (Ptr{aws_signable}, Ptr{Ptr{aws_input_stream}}), signable, out_input_stream)
end

"""
    aws_signable_new_http_request(allocator, request)

Creates a signable wrapper around an http request.

# Arguments
* `allocator`: memory allocator to use to create the signable
* `request`: http request to create a signable for
# Returns
the new signable object, or NULL if failure
### Prototype
```c
struct aws_signable *aws_signable_new_http_request(struct aws_allocator *allocator, struct aws_http_message *request);
```
"""
function aws_signable_new_http_request(allocator, request)
    ccall((:aws_signable_new_http_request, libaws_c_auth), Ptr{aws_signable}, (Ptr{aws_allocator}, Ptr{aws_http_message}), allocator, request)
end

"""
    aws_signable_new_chunk(allocator, chunk_data, previous_signature)

Creates a signable that represents a unit of chunked encoding within an http request. This can also be used for Transcribe event signing with encoded payload as chunk\\_data.

# Arguments
* `allocator`: memory allocator use to create the signable
* `chunk_data`: stream representing the data in the chunk; it should be in its final, encoded form
* `previous_signature`: the signature computed in the most recent signing that preceded this one. It can be found by copying the "signature" property from the signing\\_result of that most recent signing.
# Returns
the new signable object, or NULL if failure
### Prototype
```c
struct aws_signable *aws_signable_new_chunk( struct aws_allocator *allocator, struct aws_input_stream *chunk_data, struct aws_byte_cursor previous_signature);
```
"""
function aws_signable_new_chunk(allocator, chunk_data, previous_signature)
    ccall((:aws_signable_new_chunk, libaws_c_auth), Ptr{aws_signable}, (Ptr{aws_allocator}, Ptr{aws_input_stream}, aws_byte_cursor), allocator, chunk_data, previous_signature)
end

"""
    aws_signable_new_trailing_headers(allocator, trailing_headers, previous_signature)

Creates a signable wrapper around a set of headers.

# Arguments
* `allocator`: memory allocator use to create the signable
* `trailing_headers`: http headers to create a signable for
* `previous_signature`: the signature computed in the most recent signing that preceded this one. It can be found by copying the "signature" property from the signing\\_result of that most recent signing.
# Returns
the new signable object, or NULL if failure
### Prototype
```c
struct aws_signable *aws_signable_new_trailing_headers( struct aws_allocator *allocator, struct aws_http_headers *trailing_headers, struct aws_byte_cursor previous_signature);
```
"""
function aws_signable_new_trailing_headers(allocator, trailing_headers, previous_signature)
    ccall((:aws_signable_new_trailing_headers, libaws_c_auth), Ptr{aws_signable}, (Ptr{aws_allocator}, Ptr{aws_http_headers}, aws_byte_cursor), allocator, trailing_headers, previous_signature)
end

"""
    aws_signable_new_canonical_request(allocator, canonical_request)

Creates a signable that represents a pre-computed canonical request from an http request

# Arguments
* `allocator`: memory allocator use to create the signable
* `canonical_request`: text of the canonical request
# Returns
the new signable object, or NULL if failure
### Prototype
```c
struct aws_signable *aws_signable_new_canonical_request( struct aws_allocator *allocator, struct aws_byte_cursor canonical_request);
```
"""
function aws_signable_new_canonical_request(allocator, canonical_request)
    ccall((:aws_signable_new_canonical_request, libaws_c_auth), Ptr{aws_signable}, (Ptr{aws_allocator}, aws_byte_cursor), allocator, canonical_request)
end

# typedef void ( aws_signing_complete_fn ) ( struct aws_signing_result * result , int error_code , void * userdata )
"""
Gets called by the signing function when the signing is complete.

Note that result will be destroyed after this function returns, so either copy it, or do all necessary adjustments inside the callback.

When performing event or chunk signing, you will need to copy out the signature value in order to correctly configure the signable that wraps the event or chunk you want signed next. The signature is found in the "signature" property on the signing result. This value must be added as the "previous-signature" property on the next signable.
"""
const aws_signing_complete_fn = Cvoid

"""
    aws_signing_config_type

A primitive RTTI indicator for signing configuration structs

There must be one entry per config structure type and it's a fatal error to put the wrong value in the "config\\_type" member of your config structure.
"""
@cenum aws_signing_config_type::UInt32 begin
    AWS_SIGNING_CONFIG_AWS = 1
end

"""
    aws_signing_config_base

All signing configuration structs must match this by having the config\\_type member as the first member.
"""
struct aws_signing_config_base
    config_type::aws_signing_config_type
end

"""
    aws_sign_request_aws(allocator, signable, base_config, on_complete, userdata)

(Asynchronous) entry point to sign something (a request, a chunk, an event) with an AWS signing process. Depending on the configuration, the signing process may or may not complete synchronously.

# Arguments
* `allocator`: memory allocator to use throughout the signing process
* `signable`: the thing to be signed. See signable.h for common constructors for signables that wrap different types.
* `base_config`: pointer to a signing configuration, currently this must be of type [`aws_signing_config_aws`](@ref)
* `on_complete`: completion callback to be invoked when signing has finished
* `user_data`: opaque user data that will be passed to the completion callback
# Returns
AWS\\_OP\\_SUCCESS if the signing attempt was *initiated* successfully, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_sign_request_aws( struct aws_allocator *allocator, const struct aws_signable *signable, const struct aws_signing_config_base *base_config, aws_signing_complete_fn *on_complete, void *userdata);
```
"""
function aws_sign_request_aws(allocator, signable, base_config, on_complete, userdata)
    ccall((:aws_sign_request_aws, libaws_c_auth), Cint, (Ptr{aws_allocator}, Ptr{aws_signable}, Ptr{aws_signing_config_base}, Ptr{aws_signing_complete_fn}, Ptr{Cvoid}), allocator, signable, base_config, on_complete, userdata)
end

"""
    aws_verify_sigv4a_signing(allocator, signable, base_config, expected_canonical_request_cursor, signature_cursor, ecc_key_pub_x, ecc_key_pub_y)

Test-only API used for cross-library signing verification tests

Verifies: (1) The canonical request generated during sigv4a signing of the request matches what is passed in (2) The signature passed in is a valid ECDSA signature of the hashed string-to-sign derived from the canonical request

# Arguments
* `allocator`: memory allocator to use throughout the signing verification process
* `signable`: the thing to be signed. See signable.h for common constructors for signables that wrap different types.
* `base_config`: pointer to a signing configuration, currently this must be of type [`aws_signing_config_aws`](@ref)
* `expected_canonical_request_cursor`: expected result when building the canonical request
* `signature_cursor`: the actual signature computed from a previous signing of the signable
* `ecc_key_pub_x`: the x coordinate of the public part of the ecc key to verify the signature
* `ecc_key_pub_y`: the y coordinate of the public part of the ecc key to verify the signature
# Returns
AWS\\_OP\\_SUCCESS if the signing attempt was *initiated* successfully, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_verify_sigv4a_signing( struct aws_allocator *allocator, const struct aws_signable *signable, const struct aws_signing_config_base *base_config, struct aws_byte_cursor expected_canonical_request_cursor, struct aws_byte_cursor signature_cursor, struct aws_byte_cursor ecc_key_pub_x, struct aws_byte_cursor ecc_key_pub_y);
```
"""
function aws_verify_sigv4a_signing(allocator, signable, base_config, expected_canonical_request_cursor, signature_cursor, ecc_key_pub_x, ecc_key_pub_y)
    ccall((:aws_verify_sigv4a_signing, libaws_c_auth), Cint, (Ptr{aws_allocator}, Ptr{aws_signable}, Ptr{aws_signing_config_base}, aws_byte_cursor, aws_byte_cursor, aws_byte_cursor, aws_byte_cursor), allocator, signable, base_config, expected_canonical_request_cursor, signature_cursor, ecc_key_pub_x, ecc_key_pub_y)
end

"""
    aws_validate_v4a_authorization_value(allocator, ecc_key, string_to_sign_cursor, signature_value_cursor)

Another helper function to check a computed sigv4a signature.

### Prototype
```c
int aws_validate_v4a_authorization_value( struct aws_allocator *allocator, struct aws_ecc_key_pair *ecc_key, struct aws_byte_cursor string_to_sign_cursor, struct aws_byte_cursor signature_value_cursor);
```
"""
function aws_validate_v4a_authorization_value(allocator, ecc_key, string_to_sign_cursor, signature_value_cursor)
    ccall((:aws_validate_v4a_authorization_value, libaws_c_auth), Cint, (Ptr{aws_allocator}, Ptr{aws_ecc_key_pair}, aws_byte_cursor, aws_byte_cursor), allocator, ecc_key, string_to_sign_cursor, signature_value_cursor)
end

"""
    aws_trim_padded_sigv4a_signature(signature)

Removes any padding added to the end of a sigv4a signature. Signature must be hex-encoded.

# Arguments
* `signature`: signature to remove padding from
# Returns
cursor that ranges over only the valid hex encoding of the sigv4a signature
### Prototype
```c
struct aws_byte_cursor aws_trim_padded_sigv4a_signature(struct aws_byte_cursor signature);
```
"""
function aws_trim_padded_sigv4a_signature(signature)
    ccall((:aws_trim_padded_sigv4a_signature, libaws_c_auth), aws_byte_cursor, (aws_byte_cursor,), signature)
end

# typedef bool ( aws_should_sign_header_fn ) ( const struct aws_byte_cursor * name , void * userdata )
"""
Documentation not found.
"""
const aws_should_sign_header_fn = Cvoid

"""
    aws_signing_algorithm

What version of the AWS signing process should we use.
"""
@cenum aws_signing_algorithm::UInt32 begin
    AWS_SIGNING_ALGORITHM_V4 = 0
    AWS_SIGNING_ALGORITHM_V4_ASYMMETRIC = 1
end

"""
    aws_signature_type

What sort of signature should be computed from the signable?
"""
@cenum aws_signature_type::UInt32 begin
    AWS_ST_HTTP_REQUEST_HEADERS = 0
    AWS_ST_HTTP_REQUEST_QUERY_PARAMS = 1
    AWS_ST_HTTP_REQUEST_CHUNK = 2
    AWS_ST_HTTP_REQUEST_EVENT = 3
    AWS_ST_CANONICAL_REQUEST_HEADERS = 4
    AWS_ST_CANONICAL_REQUEST_QUERY_PARAMS = 5
    AWS_ST_HTTP_REQUEST_TRAILING_HEADERS = 6
end

"""
    aws_signed_body_header_type

Controls if signing adds a header containing the canonical request's body value
"""
@cenum aws_signed_body_header_type::UInt32 begin
    AWS_SBHT_NONE = 0
    AWS_SBHT_X_AMZ_CONTENT_SHA256 = 1
end

"""
    __JL_Ctag_82

Documentation not found.
"""
struct __JL_Ctag_82
    use_double_uri_encode::UInt32
    should_normalize_uri_path::UInt32
    omit_session_token::UInt32
end
function Base.getproperty(x::Ptr{__JL_Ctag_82}, f::Symbol)
    f === :use_double_uri_encode && return (Ptr{UInt32}(x + 0), 0, 1)
    f === :should_normalize_uri_path && return (Ptr{UInt32}(x + 0), 1, 1)
    f === :omit_session_token && return (Ptr{UInt32}(x + 0), 2, 1)
    return getfield(x, f)
end

function Base.getproperty(x::__JL_Ctag_82, f::Symbol)
    r = Ref{__JL_Ctag_82}(x)
    ptr = Base.unsafe_convert(Ptr{__JL_Ctag_82}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{__JL_Ctag_82}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


"""
    aws_signing_config_aws

A configuration structure for use in AWS-related signing. Currently covers sigv4 only, but is not required to.
"""
struct aws_signing_config_aws
    data::NTuple{216, UInt8}
end

function Base.getproperty(x::Ptr{aws_signing_config_aws}, f::Symbol)
    f === :config_type && return Ptr{aws_signing_config_type}(x + 0)
    f === :algorithm && return Ptr{aws_signing_algorithm}(x + 4)
    f === :signature_type && return Ptr{aws_signature_type}(x + 8)
    f === :region && return Ptr{aws_byte_cursor}(x + 16)
    f === :service && return Ptr{aws_byte_cursor}(x + 32)
    f === :date && return Ptr{aws_date_time}(x + 48)
    f === :should_sign_header && return Ptr{Ptr{aws_should_sign_header_fn}}(x + 144)
    f === :should_sign_header_ud && return Ptr{Ptr{Cvoid}}(x + 152)
    f === :flags && return Ptr{__JL_Ctag_82}(x + 160)
    f === :signed_body_value && return Ptr{aws_byte_cursor}(x + 168)
    f === :signed_body_header && return Ptr{aws_signed_body_header_type}(x + 184)
    f === :credentials && return Ptr{Ptr{aws_credentials}}(x + 192)
    f === :credentials_provider && return Ptr{Ptr{aws_credentials_provider}}(x + 200)
    f === :expiration_in_seconds && return Ptr{UInt64}(x + 208)
    return getfield(x, f)
end

function Base.getproperty(x::aws_signing_config_aws, f::Symbol)
    r = Ref{aws_signing_config_aws}(x)
    ptr = Base.unsafe_convert(Ptr{aws_signing_config_aws}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{aws_signing_config_aws}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

"""
    aws_signing_algorithm_to_string(algorithm)

Returns a c-string that describes the supplied signing algorithm

# Arguments
* `algorithm`: signing algorithm to get a friendly string name for
# Returns
friendly string name of the supplied algorithm, or "Unknown" if the algorithm is not recognized
### Prototype
```c
const char *aws_signing_algorithm_to_string(enum aws_signing_algorithm algorithm);
```
"""
function aws_signing_algorithm_to_string(algorithm)
    ccall((:aws_signing_algorithm_to_string, libaws_c_auth), Ptr{Cchar}, (aws_signing_algorithm,), algorithm)
end

"""
    aws_validate_aws_signing_config_aws(config)

Checks a signing configuration for invalid settings combinations.

# Arguments
* `config`: signing configuration to validate
# Returns
- AWS\\_OP\\_SUCCESS if the configuration is valid, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_validate_aws_signing_config_aws(const struct aws_signing_config_aws *config);
```
"""
function aws_validate_aws_signing_config_aws(config)
    ccall((:aws_validate_aws_signing_config_aws, libaws_c_auth), Cint, (Ptr{aws_signing_config_aws},), config)
end

"""
    aws_signing_result_property

Documentation not found.
"""
struct aws_signing_result_property
    name::Ptr{aws_string}
    value::Ptr{aws_string}
end

"""
    aws_signing_result

A structure for tracking all the signer-requested changes to a signable. Interpreting these changes is signing-algorithm specific.

A signing result consists of

(1) Properties - A set of key-value pairs (2) Property Lists - A set of named key-value pair lists

The hope is that these two generic structures are enough to model the changes required by any generic message-signing algorithm.

Note that the key-value pairs of a signing\\_result are different types (but same intent) as the key-value pairs in the signable interface. This is because the signing result stands alone and owns its own copies of all values, whereas a signable can wrap an existing object and thus use non-owning references (like byte cursors) if appropriate to its implementation.
"""
struct aws_signing_result
    allocator::Ptr{aws_allocator}
    properties::aws_hash_table
    property_lists::aws_hash_table
end

"""
    aws_signing_result_init(result, allocator)

Initialize a signing result to its starting state

# Arguments
* `result`: signing result to initialize
* `allocator`: allocator to use for all memory allocation
# Returns
AWS\\_OP\\_SUCCESS if initialization was successful, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_signing_result_init(struct aws_signing_result *result, struct aws_allocator *allocator);
```
"""
function aws_signing_result_init(result, allocator)
    ccall((:aws_signing_result_init, libaws_c_auth), Cint, (Ptr{aws_signing_result}, Ptr{aws_allocator}), result, allocator)
end

"""
    aws_signing_result_clean_up(result)

Clean up all resources held by the signing result

# Arguments
* `result`: signing result to clean up resources for
### Prototype
```c
void aws_signing_result_clean_up(struct aws_signing_result *result);
```
"""
function aws_signing_result_clean_up(result)
    ccall((:aws_signing_result_clean_up, libaws_c_auth), Cvoid, (Ptr{aws_signing_result},), result)
end

"""
    aws_signing_result_set_property(result, property_name, property_value)

Sets the value of a property on a signing result

# Arguments
* `result`: signing result to modify
* `property_name`: name of the property to set
* `property_value`: value that the property should assume
# Returns
AWS\\_OP\\_SUCCESS if the set was successful, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_signing_result_set_property( struct aws_signing_result *result, const struct aws_string *property_name, const struct aws_byte_cursor *property_value);
```
"""
function aws_signing_result_set_property(result, property_name, property_value)
    ccall((:aws_signing_result_set_property, libaws_c_auth), Cint, (Ptr{aws_signing_result}, Ptr{aws_string}, Ptr{aws_byte_cursor}), result, property_name, property_value)
end

"""
    aws_signing_result_get_property(result, property_name, out_property_value)

Gets the value of a property on a signing result

# Arguments
* `result`: signing result to query from
* `property_name`: name of the property to query the value of
* `out_property_value`: output parameter for the property value
# Returns
AWS\\_OP\\_SUCCESS if the get was successful, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_signing_result_get_property( const struct aws_signing_result *result, const struct aws_string *property_name, struct aws_string **out_property_value);
```
"""
function aws_signing_result_get_property(result, property_name, out_property_value)
    ccall((:aws_signing_result_get_property, libaws_c_auth), Cint, (Ptr{aws_signing_result}, Ptr{aws_string}, Ptr{Ptr{aws_string}}), result, property_name, out_property_value)
end

"""
    aws_signing_result_append_property_list(result, list_name, property_name, property_value)

Adds a key-value pair to a named property list. If the named list does not yet exist, it will be created as an empty list before the pair is added. No uniqueness checks are made against existing pairs.

# Arguments
* `result`: signing result to modify
* `list_name`: name of the list to add the property key-value pair to
* `property_name`: key value of the key-value pair to append
* `property_value`: property value of the key-value pair to append
# Returns
AWS\\_OP\\_SUCCESS if the operation was successful, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_signing_result_append_property_list( struct aws_signing_result *result, const struct aws_string *list_name, const struct aws_byte_cursor *property_name, const struct aws_byte_cursor *property_value);
```
"""
function aws_signing_result_append_property_list(result, list_name, property_name, property_value)
    ccall((:aws_signing_result_append_property_list, libaws_c_auth), Cint, (Ptr{aws_signing_result}, Ptr{aws_string}, Ptr{aws_byte_cursor}, Ptr{aws_byte_cursor}), result, list_name, property_name, property_value)
end

"""
    aws_signing_result_get_property_list(result, list_name, out_list)

Gets a named property list on the signing result. If the list does not exist, *out\\_list will be set to null

# Arguments
* `result`: signing result to query
* `list_name`: name of the list of key-value pairs to get
* `out_list`: output parameter for the list of key-value pairs
### Prototype
```c
void aws_signing_result_get_property_list( const struct aws_signing_result *result, const struct aws_string *list_name, struct aws_array_list **out_list);
```
"""
function aws_signing_result_get_property_list(result, list_name, out_list)
    ccall((:aws_signing_result_get_property_list, libaws_c_auth), Cvoid, (Ptr{aws_signing_result}, Ptr{aws_string}, Ptr{Ptr{aws_array_list}}), result, list_name, out_list)
end

"""
    aws_signing_result_get_property_value_in_property_list(result, list_name, property_name, out_value)

Looks for a property within a named property list on the signing result. If the list does not exist, or the property does not exist within the list, *out\\_value will be set to NULL.

# Arguments
* `result`: signing result to query
* `list_name`: name of the list of key-value pairs to search through for the property
* `property_name`: name of the property to search for within the list
* `out_value`: output parameter for the property value, if found
### Prototype
```c
void aws_signing_result_get_property_value_in_property_list( const struct aws_signing_result *result, const struct aws_string *list_name, const struct aws_string *property_name, struct aws_string **out_value);
```
"""
function aws_signing_result_get_property_value_in_property_list(result, list_name, property_name, out_value)
    ccall((:aws_signing_result_get_property_value_in_property_list, libaws_c_auth), Cvoid, (Ptr{aws_signing_result}, Ptr{aws_string}, Ptr{aws_string}, Ptr{Ptr{aws_string}}), result, list_name, property_name, out_value)
end

"""
    aws_apply_signing_result_to_http_request(request, allocator, result)

Documentation not found.
### Prototype
```c
int aws_apply_signing_result_to_http_request( struct aws_http_message *request, struct aws_allocator *allocator, const struct aws_signing_result *result);
```
"""
function aws_apply_signing_result_to_http_request(request, allocator, result)
    ccall((:aws_apply_signing_result_to_http_request, libaws_c_auth), Cint, (Ptr{aws_http_message}, Ptr{aws_allocator}, Ptr{aws_signing_result}), request, allocator, result)
end

"""
Documentation not found.
"""
const AWS_C_AUTH_PACKAGE_ID = 6

