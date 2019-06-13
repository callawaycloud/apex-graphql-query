@isTest
public class GraphQLQueryTests {

    @isTest
    private static void readmeExample(){
        GraphQLNode human = new GraphQLNode('human')
        .setArguments(new GraphQLArgument('id', '1000'))
        .add(new Object[]{
            'name',
            'height',
            new GraphQLNode('address')
                .add(new Object[]{ 'city', 'country' })
        });
        String qry = human.build();
    }


    @isTest
    private static void simpleNode(){
        GraphQLNode n = new GraphQLNode('hello')
        .add('world');
        System.assertEquals('{hello{world}}', n.build().deleteWhitespace());
    }

    @isTest
    private static void testSimpleNodeInput(){
        GraphQLNode n = new GraphQLNode('hello')
        .setArguments(new GraphQLArgument('key', 'value'))
        .add('world');
        System.assertEquals('{hello(key:\"value\"){world}}', n.build().deleteWhitespace());
    }

    @isTest
    private static void testChildNode(){
        GraphQLNode n = new GraphQLNode('message')
        .add(
            new GraphQLNode('hello').add('world')
        );
        System.assertEquals('{message{hello{world}}}', n.build().deleteWhitespace());
    }

    @isTest
    private static void testChildOnType(){
        GraphQLNode n = new GraphQLNode('foo')
        .add(new Object[]{
            new GraphQLNode('bar')
            .setTypeFragment(true)
            .add('x')
        });
        System.assertEquals('{foo{... on bar{x}}}', n.build().remove('\n'));
    }

    private class TestVariables {
        public String foo;
        public Decimal bar;
    }
}
