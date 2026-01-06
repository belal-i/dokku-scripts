#!/bin/bash

dokku apps:create odoo

dokku postgres:create odoo-db
dokku postgres:link odoo-db odoo
