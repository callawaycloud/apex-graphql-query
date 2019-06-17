@isTest
public class GraphQLQueryTests {

    @isTest
    private static void readmeExample(){
        GraphQLNode human = new GraphQLNode('human')
        .addArguments(new GraphQLArgument('id', '1000'))
        .add(new Object[]{
            'name',
            'height',
            new GraphQLNode('address')
                .add(new Object[]{ 'city', 'country' })
        });
        GraphQLQuery qry = new GraphQLQuery(human, null);
    }


    @isTest
    private static void simpleNode(){
        GraphQLNode n = new GraphQLNode('hello')
        .add('world');
        System.assertEquals('hello{world}', n.build().deleteWhitespace());
    }

    @isTest
    private static void testSimpleArgs(){
        GraphQLNode n = new GraphQLNode('hello')
        .addArguments(new GraphQLArgument('key', 'value'))
        .add('world');
        System.assertEquals('hello(key:\"value\"){world}', n.build().deleteWhitespace());
    }

    @isTest
    private static void testChildArgs(){
        GraphQLNode n = new GraphQLNode('hello')
        .addArguments(new GraphQLArgument('input', new GraphQLArgument[]{
            new GraphQLArgument('key1', 'value1'),
            new GraphQLArgument('key2', 'value2')
        }))
        .add('world');
        System.assertEquals('hello(input:{key1:\"value1\", key2:\"value2\"}){world}', n.build().remove('\n'));
    }

    @isTest
    private static void testMultipleTopLevelArgs(){
        GraphQLNode n = new GraphQLNode('hero')
            .addArguments(new GraphQLArgument[]{ 
                new GraphQLArgument('episode', 'EMPIRE', true),
                new GraphQLArgument('robot', true)
            })
            .add('name');
        
        System.assertEquals('hero(episode:EMPIRE, robot:true){name}', n.build().remove('\n'));
    }

    @isTest
    private static void testChildNode(){
        GraphQLNode n = new GraphQLNode('message')
        .add(
            new GraphQLNode('hello').add('world')
        );
        System.assertEquals('message{hello{world}}', n.build().deleteWhitespace());
    }

    @isTest
    private static void testChildOnType(){
        GraphQLNode n = new GraphQLNode('foo')
        .add(new Object[]{
            new GraphQLNode('bar')
            .setTypeFragment(true)
            .add('x')
        });
        System.assertEquals('foo{... on bar{x}}', n.build().remove('\n'));
    }

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
        
        TestVariables test = new TestVariables();
        GraphQLQuery qry = new GraphQLQuery(node, test);
        System.assertEquals(
            'mutation CreateReviewForEpisode($ep:Episode!, $review:ReviewInput!){ createReview(episode:$ep, review:$review){ stars commentary } }', 
            qry.query.replace('\n', ' ').trim()
        );
    }


    private class TestVariables {
        public String foo;
        public Decimal bar;
    }
}