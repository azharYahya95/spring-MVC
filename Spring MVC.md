1. ## Spring MVC Overview
    ### What is Spring MVC
    - Framework for Building Web Applications in Java
    - Based on Model-View-Controller design pattern
    - leverages features of the Core Spring Framework (IoC, DI)

    ### Spring MVC Benefits
    - The Spring way of building web apps UI in java
    - Leverage a set of reusable UI components
    - Help manage applications state for web requests
    - process form data: validation, conversion etc
    - flexible configuration for the view layer

    ### Behind the scenes of Spring MVC
    - Components of a Spring MVC Application
        1. **Web Pages** - A set of web pages to layout UI components
        2. **Beans** - A collection of Spring Beans(Controllers, services, etc ..)
        3. **Spring Configuration** - XML, Annotation or Java
    - How Spring MVC works behind the scenes
    ```mermaid
        flowchart TD
        WB([Web Browser]);FC([Front Controller]);C([Controller]);VT([View Template]);
        WB --> FC --Model--> C --Model--> VT --> WB
    ```
    - Front Controller
        - also known as DispatcherServlet
            - part of Spring Framework
            - already developed by Spring Dev Team
    - Controller
        - Code created by Developer
        - Contains your business logic
            - handle the request
            - Store / retrieve data (db, web service...)
            - Place data in model
        - Send to appropriate view template
    - Model 
        - Contains your data
        - Store/retrieve data via backend systems
            - database, web service, etc ...
            - Use a Spring bean if you like
        - Place your data in the model
            - Data can be any Java object/collection
    - View Template
        - Spring MVC is flexible
            - can support many view templates
        - Most common is JSP + JSTL
        - Developer creates a page
            - displays data
        - Other view templates
            - Thymeleaf, Groovy
            - Velocity, Freemaker,etc

2. ## Spring MVC Configuration
    #### Step 1: Configure Spring Dispatcher Servlet
    File: *web.xml*
    ```xml
        <web-app>

            <servlet>
                <servlet-name>dispatcher</servlet-name>
                <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>

                <init-param>
                    <param-name>contextConfigLocation</param-name>
                    <param-value>/WEB-INF/spring-mvc-demo-servlet.xml</param-value>
                </init-param>

                <load-on-startup>1</load-on-startup>
            </servlet>

        </web-app>
    ```

    #### Step 2: Set up URL mapping to Spring MVC Dispatcher Servlet
    File: *web.xml*
    ```xml
        <web-app>

            <servlet>
                <servlet-name>dispatcher</servlet-name>
                <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
            ...
            </servlet>

            <servlet-mapping>
                <servlet-name>dispatcher</servlet-name>
                <url-pattern>/</url-pattern>
            </servlet-mapping>

        </web-app>
    ```

    #### Step 3: Add support for Spring component scanning
    File: *spring-mvc-demo-servlet.xml*
    ```xml
        <beans>
            <context:component-scan base-package="com.luv2code.springdemo">
        </beans>
    ```

    #### Step 4: Add support for conversion, formatting and validation
    File: *spring-mvc-demo-servlet.xml*
    ```xml
        <beans>
            .....
            <mvc-annotation-driven/>
        </beans>
    ``` 

    #### Step 5: Configure Spring MVC View Resolver
    File: *spring-mvc-demo-servlet.xml*
    ```xml
        <beans>
           .....
           <bean
                class="org.springframework.web.servlet.view.InternalResourceViewResolver">
                <property name="prefix" value="/WEB-INF/view/" />
                <property name="suffix" value=".jsp" />
           </bean>
        </beans>
    ``` 
    - How path of JSP file created based on this configuration?
        - /WEB-INF/view/show-student-list.jsp

3. ## Creating Controllers and Views
    ### Step By step Development process to create Controllers and View

    #### Step 1: Create a Controller class
    - Annotate class with @Controller 
    - @Controller inherits from @Component, so it support scanning
    ```java
        @Controller
        public class HomeController {

        }
    ```
    
    #### Step 2: Define Controller method
    ```java
        @Controller
        public class HomeController {
            public String showMyPage(){
                ...
            }
        }
    ```

    #### Step 3: Add request mapping to Controller method
    ``` java
        @Controller
        public class HomeController {

            @RequestMapping("/")
            public String showMyPage(){
                ...
            }
        }
    ```

    #### Step 4: Return view name
    ``` java
        @Controller
        public class HomeController {

            @RequestMapping("/")
            public String showMyPage(){
                return "main-menu";
            }
        }
    ```

    #### Step 5: Develop view page
    File: */WEB-INF/view/main-menu.jsp*
    ``` html
        <html>
            <body>
                <h2>Spring MVC Demo - Home Page</h2>
            </body>
        </html>
    ```




    ### Reading HTML form data
    
    1. #### Development Process to read HTML form data
    - Create Controller class
    - Show HTML form
        - Create controller method to show HTML form
            ```java
                @Controller
                public class HelloWorldController {
                    @RequestMapping("/showForm")
                    public String showForm() {
                        return "helloworld-form";
                    }
                }
            ```
        - Create view Page for HTML form
            ```html
                <!DOCTYPE html>
                <html>
                    <head>
                        <title>Hello World - Input Form</title>
                    </head>
                    <body>
                        <form action="processForm" method="GET">
                            <input type="text" name="studentName" 
                                placeholder="What's your name?" />
                                
                            <input type="submit"/>
                        
                        </form>
                    </body>
                </html>
            ```
    - Process HTML form
        - Create controller mehtod to process HTML form
        ```java
            @Controller
            public class HelloWorldController {
                
                .....
                
                //need a controller method to process the HTML form
                @RequestMapping("/processForm")
                public String processForm() {
                    return "helloworld";
                }
            }
        ```
        - Develop view page for  Confirmation
        ```html
            <!DOCTYPE html>
            <html>
                <body>
                    Hello world of Spring!  
                    <br><br>
                    Student name: ${param.studentName}
                </body>
            </html>
        ```

    ### Add Data to the Spring Model
    1. #### Spring Model
    - Container of your application data
    - in your Controller
        - can put strings, objects, info from database, etc...
    - Your view page (JSP) can access data from model

    2. Passing Model to your Controller
    *1. java file*
    ```java
        @RequestMapping("/processFormVersionTwo")
        public String letsShoutDude(HttpServletRequest request, Model model){
            //read request parameter from the HTML form
            String theName = request.getParameter("studentName");

            //do operation on the datas
            theName = theName.toUpperCase();

            //create the message
            String result = "Yo! "+theName;

            //add message to the model
            model.addAttribute("message", result);

            return "helloWorld";
        }
    ```
    *2. jsp file*
    - use the ${...} sign to show the data
    ```jsp
        <html>
            <body>
                Hello world of Spring!
                ...

                The message: ${message}
            </body>
        </html>
    ```


4. ## Request Params and Request Mappings
    1. ### Reading HTML Form Data with @RequestParam Annotation
        - Instead of using HttpServletRequest to bind param, we can use @RequestParam annotation
        ```java
            @RequestMapping("/processFormVersionTwo")
            public String letsShoutDude(
                @RequestParam("studentName") String theName, 
                Model model
            ){
                //now we can use the variable: theName
            }
        ```
        - Behind the scenes:
            - Spring will read param from request: studentName
            - Bind it to the variable: theName

    2. ### Controller Level Request Mapping
        ```java
            @RequestMapping("funny")
            public class FunnyController{

                @RequestMapping("/showForm") // /funny/showForm
                public String showForm(){
                    ....
                }

                @RequestMapping("/processForm") // /funny/processForm
                public String process(HttpServletRequest request, Model mode){
                    ....
                }
            }
        ```
        - *funny* is **Controller mapping** / parent mapping
        - *showForm* and *processForm* are **method mapping** / child mapping
        - will got error that show *Ambiguous mapping* message, if got 2 method with same path
        - relative path of showing the form and then submitting to relative path

5. ## Form Tags and Data Binding
    1. ### Spring MVC Form Tags
        - Data Binding
            - Spring MVC Form Tags can make use of data binding
            - Automatically setting / retrieving data from a Java Object / bean
        - Form  tags will generate HTML for you

        |Form Tag|Description|
        |---|---|
        |form:form|main form container|
        |form:input|text field|
        |form:textarea|multi-line text field|
        |form:checkBox|check box|
        |form:radiobutton|radio buttons|
        |form:select|drop down list|
        |more...||

        - more tags? www.luv2code.com/spring-mvc-form-tags
        - Reference Spring MVC form tags?
            - specify the Spring namespace at beginning of JSP file
            `<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form %>"`
    2. ### Text Fields
        1. **In Spring Controller**
            - before show the form, you must add the a model attribute
            - this is a bean that will hold form data for data binding
            ```java
                @RequestMapping("/showForm")
                public String showForm(Model theModel){
                    theModel.addAttribute("student", new Student());
                    return "student-form";
                }
            ```
        2. **Setting up HTML form - Data Binding**
            ```html
                <form:form action="processForm" modelAttribute="student">
                    First Name: <form:input path="firstName" />
                    <br><br>
                    Last Name: <form:input path="lastName" />
                    <br><br>
                    <input type="submit" value="Submit" />
                </form:form>
            ```
            - when form is loaded, Spring MVC will call get method from Model class, if its null, it will give empty value
            - when form submitted, Spring MVC will call setter method
        
        3. **Handling Form Submission in controller**
            ```java
                @RequestMapping("/processForm")
                public String processForm(@ModelAttribute("student") Student theStudent){
                    System.out.println("theStudent: "+ theStudent.getLastName());
                    return "student-confirmation";
                }
            ```
            - @ModelAttribute: bind form data to Object
            - Behind the Scenes: the Object is populated with form Data
                - it will handle automatically, this is benefit of using Spring MVC form tag
        
        4. Confirmation Page
            ```jsp
                <html>
                    <body>
                        The Student is Confirmed: ${student.firstName} ${student.lastName}
                    </body>
                </html>
            ```
    3. ### Drop Down list
        ```jsp
        <form:form action="processForm" modelAttribute="student">
            <form:select path="country"><!-- java Object will call student.setCountry -->
                
                <form:option value="Brazil" label="Brazil"/>
                <form:option value="France" label="France"/>
                <form:option value="Germany" label="Germany"/>
                <form:option value="India" label="India"/>
            </form:select>
	    </form:form>
        ```
        - country is property for Data Binding
        - will call student.setCountry upon selecting
        - get selection from java file
            *java file*
            ```java
                private LinkedHashMap<String, String> countryOptions;
                public Student() {
                    countryOptions = new LinkedHashMap<>();
                    
                    countryOptions.put("BR", "Brazil");
                    countryOptions.put("FR", "France");
                }
                public LinkedHashMap<String, String> getCountryOptions() {
                    return countryOptions;
                }

                public void setCountryOptions(LinkedHashMap<String, String> countryOptions) {
                    this.countryOptions = countryOptions;
                }
            ```
            *jsp file*
            ```jsp
                <form:select path="country">
                    <form:options items="${student.countryOptions}"/>
                </form:select>
            ```
    4. ### Radio Buttons
        1. Code Example
            ```jsp
                Java <form:radiobutton path="favouriteLanguage" value="Java">
                C# <form:radiobutton path="favouriteLanguage" value="C#">
                PHP <form:radiobutton path="favouriteLanguage" value="PHP">
                Ruby <form:radiobutton path="favouriteLanguage" value="Ruby">
            ```
    5. ### Checkbox
        1. Code Example
        ```jsp
            Linux <form:checkbox path="operatingSystems" value="Linux">
            MacOS <form:checkbox path="operatingSystems" value="MacOS">
            MS Windows <form:checkbox path="operatingSystems" value="MS Windows">
        ```
        java: 
        ```java
            private String[] operatingSystems;
            public String[] getOperatingSystems() {
                return operatingSystems;
            }

            public void setOperatingSystems(String[] operatingSystems) {
                this.operatingSystems = operatingSystems;
            }
        ```
        confirmation-page:
        ```jsp
            <ul>
                <c:foreach var="temp" items="${student.operatingSystems}">
                    <li> ${temp} </li>
                </c:foreach>
            </ul>
        ```

6. ## Spring MVC Form Validation
    1. ### Overview
        - **Why we need Validation?**
            - Check user input form for 
                a. required fields
                b. valid number in a range
                c. valid format (postal code)
                d. custom Business rule
        - **Java standard Bean Validation API**
            - defines metadata model and API for entity validation
            - no tied to either web tier or persistence tier
            - Available for server-side apps and alos client-side (JavaFX / SwingApps)
            - http://www.beanvalidaton.org
        - **Spring Validation**
            - Spring 4 and Higher support Bean Validation API
            - preferred method for validation when building Spring Apps
            - Simply add Validation JARs to our project
        - **Bean Validation Features**
            - required
            - validate length
            - validate numbers
            - validate with regular expressions
            - custom Validation
        - **Validation Annotations**
            |Annotations|Description|
            |---|---|
            |@NotNull|Checks that the annotated value is not null|
            |@Min|Must be a number >= value|  
            |@Max|Must be a number <>= value|
            |@Size|Size must math the given size|
            |@Pattern|Must match a regular expression pattern|
            |@Future/@Past|Date must be in future or past of given value|
            |others ...|...|
    2. ### Setting environment for Form Validation
        - **we can use Hibernate**
            - its started as ORM project, but already expanded the area, and got separated project for validator
            - http://www.hibernate.org/validator
            - Spring 5 is not compatible with Hibernate Validator 7, we need to use Hibernate Validator 6.2, and it have same feature with version 7
    3. ### Checking for the required fields
        1. Add validation rule to Customer Class
            ```java
                import javax.validation.constraints.NotNull;
                import javax.validation.constraints.Size;

                public class Customer{
                    private String firstName;

                    @NotNull(message="is required")
                    @Size(min=1, message="is required")
                    private String lastName;

                    //getter / setter methods
                }
            ```
        2. Display error message on HTML form
            *customer-form.jsp*
            ```jsp
                    <form:form action="processForm" modelAttribute="customer">
                        First Name: <form:input path="firstName" />

                        <br><br>

                        Last Name: <form:input path="lastName" />
                        <form:errors path="lastName" cssClass="error"/>

                        <br><br>

                        <input type="submit" value="Submit"/>
                    </form:form>
            ```
        3. Perform validation in the Controller class
            ```java
                    @RequestMapping("/processForm")
                    public String processForm(@Valid @ModelAttribute("customer") Customer customer, 
                        @BindingResult theBindingResult){
                        if(theBindingResult.hasErrors()){
                            return "customer-form";
                        }else{
                            return "customer-confirmation";
                        }
                    }
            ```
            - @Valid: Perform validation rules on Customer object
            - @BindingResult: Results of validation placed in the BindingResult
            - BindingResult parameter must appear immediately after the model attribute
        4. Update confirmation Class
        - @InitBinder
            - can use this as a preprocess
            ```java
                @InitBinder
                public void initBinder(WebDataBinder dataBinder) {
                    StringTrimmerEditor stringTrimmerEditor = new StringTrimmerEditor(true);
                    dataBinder.registerCustomEditor(String.class, stringTrimmerEditor);
                }
            ```
            - based on code above
                - it pre-process every String form data
                - Remove leading and trailing white space
    4. ### Validate a Number Range
        1. Development process
            a. Add Validation rule to Customer Class
                ```java
                    import javax.validation.constraints.Min;
                    import javax.validation.constraints.Max;

                    public class Customer{
                        
                        @Min(value=0, message="must be greater than or equal to zero")
                        @Max(value=10, message="must be less than or equal to 10")
                        private int freePasses;

                        // getter/setter methods
                    }
                ```
            b. Display error messages on HTML form
            c. Perform validation on a Controller class
            d. Update confirmation class
    
    5. ### Applying regular Expressions
        1. https://docs.oracle.com/javase/tutorial/essential/regex
        2. sample code
        ```java
            import javax.validation.constraints.Pattern;

            public class Customer{
                @Pattern(regexp="^[a-zA-Z0-9]{5}", message="only 5 digits/character")
                private String postalCode;
            }
        ```
    6. ### Make Integer field required
        1. We can use Integer instead of int, because Integer can take null value, and we can handle it by using @NonNull annotation
    
    7. ### Handle String Input for Integer fields using custom Message
        1. Development Process
            a. Create custom error message
            - *src/resources/message.properties*
            `typeMismatch.customer.freePasses=Invalid number`
                - *typeMismatch* - Error Type
                - *customer* - Spring model attribute name
                - *freePasses* - Field name
                - *Invalid number* - our custom message
            - we can get from debugging BindingResult
                ```
                Field error in object 'customer' on field 'freePasses': rejected value [sasdas]; codes [typeMismatch.customer.freePasses,typeMismatch.freePasses,typeMismatch.java.lang.Integer,typeMismatch];
                ```
            b. Load custom messages resources in Spring config file
            - *WebContent/WEB-INF/spring-mvc-demo-servlet.xml*
            ```
                <!-- Load custom message resources -->
                <bean id="messageSource" 
                        class="org.springframework.context.support.ResourceBundleMessageSource">
                    
                    <property name="basenames" value="resources/messages"/>
                    
                </bean>
            ```
    8. ### Spring MVC Custom Validation
        1. Development process to create custom Validation rule
            a. Create @CourseCode annotation - `@CourseCode(value="LUV", message="...")`
            ```java
                    @Constraint(validatedBy = CourseCodeConstraintValidator.class)
                    @Target({ElementType.METHOD, ElementType.FIELD})
                    @Retention(RetentionPolicy.RUNTIME)
                    public @interface CourseCode{
                        //define default course code
                        public String value default "LUV";

                        //define default error message
                        public String message() default "must start with LUV";
                    }
            ```
            - we use @interface to create custom annotation
            - @Constraint - to describe the annotation, it will be validatedBy ...
            - @Target - where we want to apply our annotation
            - @Retention - how long should we retain it

            b. Create CourseCodeConstraintValidator
            ```java
                import javax.validation.ConstraintValidator;
                import javax.validation.ConstraintValidatorContext;

                public class CourseCodeConstraintValidator implements ConstraintValidator<CourseCode, String>{
                    private String coursePrefix;

                    @Override
                    public void initialize(CourseCode theCourseCode){                            
                        coursePrefix = theCourseCode.value();
                    }

                    @Override
                    public boolean isValid(String theCode, ConstraintValidatorContext theConstraintValidatorContext){
                        boolean result;

                        if(theCode != null){
                            result = theCode.startsWith(coursePrefix);
                        }else{                                      
                            result = true;
                        }
                        return result;
                    }
                }
            ```
            - `implements ConstraintValidator<CourseCode, String>`
                - CourseCode - our annotation
                - String - type of data to validate against

