#########
# Copyright (c) 2015 GigaSpaces Technologies Ltd. All rights reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  * See the License for the specific language governing permissions and
#  * limitations under the License.

START_TIMEOUT = 60
START_INTERVAL = 1
STOP_TIMEOUT = 60
STOP_INTERVAL = 1
BROKER_PORT = 5672
REST_PORT = 80
REST_PROTOCOL = 'http'
SECURITY_ENABLED = False
FILE_SERVER_PORT = 53229
FILE_SERVER_PROTOCOL = 'http'
VERIFY_REST_CERTIFICATE = False
MIN_WORKERS = 0
MAX_WORKERS = 5
BROKER_URL = 'amqp://{username}:{password}@{host}:{port}//'
DELETE_AMQP_QUEUE_BEFORE_START = True
DAEMON_FORCE_DELETE = False
CLOUDIFY_AGENT_PREFIX = 'cfy-agent'
LOG_LEVEL = 'debug'
CELERY_TASK_RESULT_EXPIRES = 600
