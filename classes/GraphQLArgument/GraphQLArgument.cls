public virtual class GraphQLArgument {
  public String name;
  public Object value; //string | GraphQLArgument | GraphQLArgument[]
  public Boolean isVariable;

  public GraphQLArgument(String name, Object value) {
    this.name = name;
    this.value = value;
    this.isVariable = false;
  }

  public GraphQLArgument(String name, Object value, Boolean isVariable) {
    this.name = name;
    this.value = value;
    this.isVariable = isVariable;
  }

  public virtual string build() {
    String qry = this.name + ':';
    if (
      isVariable ||
      this.value instanceof Integer ||
      this.value instanceof Decimal ||
      this.value instanceof Boolean
    ) {
      qry += String.valueOf(this.value);
    } else if (this.value instanceof DateTime) {
      qry +=
        '\"' +
        ((DateTime) this.value).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'') +
        '\"';
    } else if (this.value instanceof GraphQLArgument) {
      qry += '{' + ((GraphQLArgument) this.value).build() + '}';
    } else if (this.value instanceof GraphQLArgument[]) {
      String[] argsStrings = new List<String>{};
      for (GraphQLArgument arg : (GraphQLArgument[]) this.value) {
        argsStrings.add(arg.build());
      }
      qry += '{' + String.join(argsStrings, ', ') + '}';
    } else {
      // default to string
      qry += '\"' + String.valueOf(this.value) + '\"';
    }
    return qry;
  }
}