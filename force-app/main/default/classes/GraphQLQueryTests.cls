// Tests using modified examples from https://graphql.org/learn/queries/
@isTest
public class GraphQLQueryTests {

    // {
    //   hero {
    //     name
    //   }
    // }
    @isTest
    private static void simpleNode(){
        GraphQLNode node = new GraphQLNode('hero')
        .add('name');
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero{name}}', qry.query.deleteWhitespace());
    }

    // {
    //   hero(name: "luke skywalker") {
    //     id
    //   }
    // }
    @isTest
    private static void testStringArg(){
        GraphQLNode node = new GraphQLNode('hero')
        .addArguments(new GraphQLArgument('name', 'luke skywalker'))
        .add('id');
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero(name:\"luke skywalker\"){id}}', qry.query.remove('\n'));
    }

    // {
    //   hero(id: 1000) {
    //     name
    //   }
    // }
    @isTest
    private static void testNumberArg(){
        GraphQLNode node = new GraphQLNode('hero')
        .addArguments(new GraphQLArgument('id', 1000))
        .add('name');
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero(id:1000){name}}', qry.query.remove('\n'));
    }

    // {
    //   hero(isJedi: true) {
    //     name
    //   }
    // }
    @isTest
    private static void testBooleanArg(){
        GraphQLNode node = new GraphQLNode('hero')
        .addArguments(new GraphQLArgument('isJedi', true))
        .add('name');
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero(isJedi:true){name}}', qry.query.remove('\n'));
    }

    // {
    //   hero(episode: EMPIRE) {
    //     name
    //   }
    // }
    @isTest
    private static void testStringVariableArg(){
        GraphQLNode node = new GraphQLNode('hero')
        .addArguments(new GraphQLArgument('episode', 'EMPIRE', true))
        .add('name');
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero(episode:EMPIRE){name}}', qry.query.remove('\n'));
    }

    // {
    //   hero(attr: {droid: false, weapon: "lightsaber"}) {
    //     name
    //   }
    // }
    @isTest
    private static void testNestedArgs(){
        GraphQLNode node = new GraphQLNode('hero')
        .addArguments(new GraphQLArgument('attr', new GraphQLArgument[]{
            new GraphQLArgument('droid', false),
            new GraphQLArgument('weapon', 'lightsaber')
        }))
        .add('name');
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero(attr:{droid:false, weapon:\"lightsaber\"}){name}}', qry.query.remove('\n'));
    }

    // {
    //   hero(episode: EMPIRE, dies: true}) {
    //     name
    //   }
    // }
    @isTest
    private static void testMultipleArgs(){
        GraphQLNode node = new GraphQLNode('hero')
            .addArguments(new GraphQLArgument[]{ 
                new GraphQLArgument('episode', 'EMPIRE', true),
                new GraphQLArgument('dies', true)
            })
            .add('name');
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero(episode:EMPIRE, dies:true){name}}', qry.query.remove('\n'));
    }

    // {
    //   hero {
    //     attr {
    //        weapon
    //     }
    //   }
    // }
    @isTest
    private static void testNestedNode(){
        GraphQLNode node = new GraphQLNode('hero')
        .add(
            new GraphQLNode('attr').add('weapon')
        );
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero{attr{weapon}}}', qry.query.remove('\n'));
    }

    // {
    //   hero {
    //     name
    //     ... on Droid {
    //        primaryFunction
    //     }
    //   }
    // }
    @isTest
    private static void testChildOnType(){
        GraphQLNode node = new GraphQLNode('hero')
        .add(new Object[]{
            'name',
            new GraphQLNode('Droid')
            .setTypeFragment(true)
            .add('primaryFunction')
        });
        GraphQLQuery qry = new GraphQLQuery(node, null);
        System.assertEquals('{hero{name... on Droid{primaryFunction}}}', qry.query.remove('\n'));
    }

    // {
    //   empireHero: hero(episode: EMPIRE) {
    //     name
    //   }
    //   jediHero: hero(episode: JEDI) {
    //     name
    //   }
    // }
    @isTest
    private static void testAlias(){
        GraphQLNode[] nodes = new GraphQLNode[]{
             new GraphQLNode('hero')
            .setAlias('empireHero')
            .addArguments(new GraphQLArgument('episode', 'EMPIRE', true))
            .add('name'),
            new GraphQLNode('hero')
            .setAlias('jediHero')
            .addArguments(new GraphQLArgument('episode', 'JEDI', true))
            .add('name')
        };
        
        GraphQLQuery qry = new GraphQLQuery(nodes, null);
        System.assertEquals('{empireHero: hero(episode:EMPIRE){name}jediHero: hero(episode:JEDI){name}}', qry.query.remove('\n'));
    }


    
    // mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
    //     createReview(episode: $ep, review: $review) {
    //         stars
    //         commentary
    //     }
    // }
    // == Variables ==
    // {
    //   "ep": "JEDI",
    //   "review": {
    //     "stars": 5,
    //     "commentary": "This is a great movie!"
    //   }
    // }
    @isTest
    private static void testOperation(){
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
        GraphQLQuery qry = new GraphQLQuery(node, createReviewVariables);
        String payload = JSON.serialize(qry);
        System.assertEquals(
            '{"variables":{"review":{"stars":5,"commentary":"This is a great movie!"},"ep":"JEDI"},"query":"mutation CreateReviewForEpisode($ep:Episode!, $review:ReviewInput!){\\ncreateReview(episode:$ep, review:$review){\\nstars\\ncommentary\\n}\\n}\\n"}',
            payload
        );
    }

    /* DTO for testOperation mutation test */
    public class CreateReviewForEpisode
    {
        public String ep { get; set; }
        public Review review { get; set; }
    }

    public class Review
    {
        public Integer stars { get; set; }
        public String commentary { get; set; }
    }

}