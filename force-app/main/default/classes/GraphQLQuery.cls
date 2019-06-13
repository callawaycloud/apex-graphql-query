public class GraphQLQuery {
    public string query;
    public string variables;
    public GraphQLQuery(string query, string variables){
        this.query = query;
        this.variables = variables;
    }

    public GraphQLQuery(GraphQLNode node, Object variables){
        this.query = buildQuery(node);
        if(variables != null){
            this.variables = JSON.serialize(variables);
        }
    }

    public GraphQLQuery(GraphQLNode[] nodes, Object variables){
        this.query = buildQuery(nodes);
        if(variables != null){
            this.variables = JSON.serialize(variables);
        }
    }

    private static string buildQuery(GraphQLNode node){
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
