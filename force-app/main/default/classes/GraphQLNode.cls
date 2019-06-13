public class GraphQLNode {
    public String id;
    public Boolean typeFrament; // transforms to "...on {id} {"
    public String alias;
    public GraphQLArgument[] args; //not sure this supports all use cases... might need to be GraphQLArgument | GraphQLArgument[]
    public Object[] children; //object or other nodes

    public GraphQLNode(String id){
        this.typeFrament = false;
        this.args = new GraphQLArgument[]{};
        this.children = new Object[]{};
        this.id = id;
    }

    //returns the current node
    public GraphQLNode setId(String id){
        this.id = id;
        return this;
    }

    //returns the current node
    public GraphQLNode setAlias(String alias){
        this.alias = alias;
        return this;
    }

    //returns the current node
    public GraphQLNode addArguments(GraphQLArgument arg){
        this.args.add(arg);
        return this;
    }

    public GraphQLNode addArguments(GraphQLArgument[] args){
        this.args.addAll(args);
        return this;
    }

    //returns the current node
    public GraphQLNode add(Object children){
        if(children instanceOf Object[]){
            this.children.addAll((Object[])children);
        }else{
            this.children.add(children);
        }
        return this;
    }

    public GraphQLNode setTypeFragment(Boolean isTypeFrag){
        this.typeFrament = isTypeFrag;
        return this;
    }

    public string build(){
        String qry = this.id;
        if(this.typeFrament){
            qry = '... on ' + this.id;
        }else if(this.alias != null){
            qry = this.alias + ': ' + qry;
        }
        
        if(this.args.size() > 0){
            String[] argsStrings = new String[]{};
            for(GraphQLArgument arg : this.args){
                argsStrings.add(arg.build());
            }
            qry += '(' + String.join(argsStrings, ', ') + ')';
        }
        
        qry += '{\n';
        for(Object child : this.children){
            if(child instanceOf GraphQLNode){
                qry += ((GraphQLNode) child).build();
            }else{
                 qry += ((String) child) + '\n';
            }
        }
        qry += '}\n';
        return qry;
    }

}
