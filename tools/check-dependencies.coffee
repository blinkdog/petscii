#!/usr/bin/env coffee
# check-dependencies.coffee
# Copyright 2021 Patrick Meade.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------

exitCode = 0

{exec} = require "child_process"

checkVersion = (dependency, version) ->
    {stdout} = await execAsync "npm --json info #{dependency}"
    {latest} = JSON.parse(stdout)["dist-tags"]
    if latest isnt version
        console.log "[OLD] #{dependency} is out of date #{version} vs. #{latest}"
        exitCode = 1

execAsync = (command) ->
    return new Promise (resolve, reject) ->
        exec command, (err, stdout, stderr) ->
            return reject err if err?
            resolve {stdout: stdout, stderr: stderr}

do ->
    project = require "../package.json"

    for dependency of project.dependencies
        await checkVersion dependency, project.dependencies[dependency]

    for dependency of project.devDependencies
        await checkVersion dependency, project.devDependencies[dependency]

    process.exit exitCode

#-------------------------------------------------------------------------------
# end of check-dependencies.coffee
