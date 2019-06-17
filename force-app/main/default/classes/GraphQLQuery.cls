public class GraphQLQuery {
    public string query;
    public Object variables;
    public GraphQLQuery(string query, Object variables){
        this.query = query;
        this.variables = variables;
    }

    public GraphQLQuery(GraphQLNode node, Object variables){
        this.query = buildQuery(node);
        this.variables = variables;
    }

    public GraphQLQuery(GraphQLNode[] nodes, Object variables){
        this.query = buildQuery(nodes);
        this.variables = variables;
    }

    private static string buildQuery(GraphQLNode node){
        if(node.operation != null){
            return node.build();
        }
        return '{\n' + node.build() + '\n}';
    }

    private static string buildQuery(GraphQLNode[] nodes){
        String[] nodeStrings = new String[]{};
        for(GraphQLNode node : nodes){
            nodeStrings.add(node.build());
        }
        return '{\n' + String.join(nodeStrings, '\n') + '\n}';
    }
}
