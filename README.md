# apex-graphql-query

A simple library for building GraphQL queries in Salesforce's Apex Language.

_some use cases still not supported_

## Examples:

### Query

```graphql
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

```java
GraphQLNode human = new GraphQLNode('human')
.setArguments(new GraphQLArgument('id', '1000'))
.add(new Object[]{
  'name',
  'height',
  new GraphQLNode('address')
    .add(new Object[]{ 'city', 'country' })
});

// create GraphQLQuery without Variables
GraphQLQuery qry = new GraphQLQuery(human, null);
System.debug(qry.query);
```

### Operations

```graphql
mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
  createReview(episode: $ep, review: $review) {
    stars
    commentary
  }
}
```

```json
{
  "ep": "JEDI",
  "review": {
    "stars": 5,
    "commentary": "This is a great movie!"
  }
}
```

**Equivalent Apex**

```java

//Variable DTOs
public class CreateReviewForEpisode{
  public String ep { get; set; }
  public Review review { get; set; }
}

public class Review{
  public Integer stars { get; set; }
  public String commentary { get; set; }
}

//Mutation Query
GraphQLNode node = new GraphQLNode('CreateReviewForEpisode')
.setOperation('mutation')
.addArguments(new GraphQLArgument('$ep', 'Episode!', true))
.addArguments(new GraphQLArgument('$review', 'ReviewInput!', true))
.add(
  new GraphQLNode('createReview')
  .addArguments(new GraphQLArgument[]{
    new GraphQLArgument('episode', '$ep', true),
    new GraphQLArgument('review', '$review', true)
  })
  .add(new Object[]{'stars', 'commentary'})
);

CreateReviewForEpisode createReviewVariables = new CreateReviewForEpisode();
createReviewVariables.ep = 'JEDI';
createReviewVariables.review = new Review();
createReviewVariables.review.stars = 5;
createReviewVariables.review.commentary = 'This is a great movie!';

// create GraphQLQuery with Variables
GraphQLQuery qry = new GraphQLQuery(node, createReviewVariables);
String payload = JSON.serialize(qry);

//... POST payload to graphQL service endpoint
```

### Additional Usage

See [Unit Tests](https://github.com/ChuckJonas/apex-graphql-query/blob/master/force-app/main/default/classes/GraphQLQueryTests.cls) for more usage examples.

## Installation

Choose your own Adventure:

### A: Unlocked Package Install

- via URL: [/packaging/installPackage.apexp?p0=04t1C000000tfGqQAI](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1C000000tfGqQAI)

**OR**

- via sfdx-cli: `sfdx force:package:install --wait 10 --publishwait 10 --package 04t1C000000tfGqQAI --noprompt -u you@yourorg`

### B: From Source

1. `sfdx force:source:convert -d deploy-package`
2. `sfdx force:mdapi:deploy -d deploy-package -u you@yourorg -w 1000`

## Contributing

Please do!
