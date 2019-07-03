# Release Instructions

## Create Package

Only one time. Skip for updates
`sfdx force:package:create -n GraphQLQuery -d "Library for building GraphQL Queries" -r force-app -t Unlocked -v ccc-prod`

## Release Update

- Create version
1. Update `versionName` & `versionNumber` in `sfdx-project.json`
2. run `sfdx force:package:version:create -p GraphQLQuery -d force-app -x --wait 10 -v ccc-prod`

- "promote" Version

1. Get `04txxxxxx` version from previous step
2. `sfdx force:package:version:promote -p 04txxxxxx`

- Update install instructions in readme

- Add release on github