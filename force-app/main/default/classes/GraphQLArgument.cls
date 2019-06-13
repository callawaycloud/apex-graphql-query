public class GraphQLArgument{
    public String name;
    public Object value; //string | GraphQLArgument | GraphQLArgument[]
    public Boolean isVariable;

    public GraphQLArgument(String name, Object value){
        this.name = name;
        this.value = value;
        this.isVariable = false;
    }

    public GraphQLArgument(String name, Object value, Boolean isVariable){
        this.name = name;
        this.value = value;
        this.isVariable = isVariable;
    }

    public string build(){
        String qry = this.name + ':';
        if(isVariable || this.value instanceOf Integer || this.value instanceOf Decimal){
            qry += String.valueOf(this.value);
        }else if(this.value instanceOf DateTime){
            qry += '\"' + ((DateTime) this.value).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'') + '\"';
        }else if(this.value instanceOf GraphQLArgument){
            qry += '{' + ((GraphQLArgument) this.value).build() + '}';
        }else if(this.value instanceOf GraphQLArgument[]){
            qry += '{';
            for(GraphQLArgument childParam : (GraphQLArgument[]) this.value){
                qry += childParam.build();
            }
            qry += '}';
        }else { // default to string
            qry += '\"' + String.valueOf(this.value) + '\"';
        }
        return qry;
    }
}