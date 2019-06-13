public class GraphQLQuery {
    public string query;
    public string variables;
    public GraphQLQuery(string query, string variables){
        this.query = query;
        this.variables = variables;
    }

    public GraphQLQuery(GraphQLNode node, Object variables){
        this.query = node.build();
        if(variables != null){
            this.variables = JSON.serialize(variables);
        }
    }
}
