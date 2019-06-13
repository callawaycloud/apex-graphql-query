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
        if(isVariable || this.value instanceOf Integer || this.value instanceOf Decimal || this.value instanceOf Boolean){
            qry += String.valueOf(this.value);
        }else if(this.value instanceOf DateTime){
            qry += '\"' + ((DateTime) this.value).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'') + '\"';
        }else if(this.value instanceOf GraphQLArgument){
            qry += '{' + ((GraphQLArgument) this.value).build() + '}';
        }else if(this.value instanceOf GraphQLArgument[]){
            String[] argsStrings = new String[]{};
            for(GraphQLArgument arg : (GraphQLArgument[]) this.value){
                argsStrings.add(arg.build());
            }
            qry += '{' + String.join(argsStrings, ', ') + '}';
        }else { // default to string
            qry += '\"' + String.valueOf(this.value) + '\"';
        }
        return qry;
    }
}