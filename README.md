# apex-graphql-query

A simple library for building GraphQL queries in Salesforce's Apex Language.  *Currently only offers parital support.*

## Example:

``` graphql
{
  human(id: "1000") {
    name
    height
    address {
        city
        country
    }
  }
}
```

**Equivalent Apex**

``` java
GraphQLNode human = new GraphQLNode('human')
.setArguments(new GraphQLArgument('id', '1000'))
.add(new Object[]{
    'name',
    'height',
    new GraphQLNode('address')
        .add(new Object[]{ 'city', 'country' })
});
String qry = human.build();
```

## Deployment

Choose your own Adventure:

### A: Unlocked Package Install

--coming soon--

### B: From Source

1. `sfdx force:source:convert -d deploy-package`
2. `sfdx force:mdapi:deploy -d deploy-package -u you@yourorg -w 1000`

## Contributing

Please do!