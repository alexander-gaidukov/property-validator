# PropertyValidator

## Overview
Property Validator is a Swift Package that allows you to add all needed validations to your properties, like email format validation, password length validation, etc. It uses Swift 5 property wrappers to wrap the property with all needed validators.

## Requirements

* iOS 10+
* Swift 5

## Getting started

### Validated properties

`@Validated` annotation allows you to created validated property. It accepts an array of validators as a parameter.

```swift
@Validated([
    NotEmptyValidator(errorMessage: "Email field can't be empty").validator,
    EmailValidator(errorMessage: "The email format is wrong").validator
])
var email: String? = nil
```

```swift
@Validated([
    NotEmptyValidator(errorMessage: "Password field can't be empty").validator,
    LengthValidator(range: 5..., errorMessage: "The password is too short").validator
])
var password: String? = nil
```
### Validator Sequence
It is also possible to create a validator sequence. For instance, you can use the following sequence for email validation
```swift
@Validated([
    NotEmptyValidator(errorMessage: "Email field can't be empty")
    .and(EmailValidator(errorMessage: "The email format is wrong"))
    .validator
])
var email: String? = nil
```
In this case the second validator will be called only if the first validator returns success. So, you will not recive both error messages if the value is empty.

You can also use the `or` sequence. It is useful if you need to validate an optional field.
```swift
@Validated([
    EmptyValidator(errorMessage: "")
    .or(EmailValidator(errorMessage: "The email format is wrong"))
    .validator
])
var email: String? = nil
```
### Validation Groups
Sometimes you need to validate a gropu of values. For instance, you need to check that `password` and `passwordConfirmation` filelds have the same values. The `ValidationGroup` protocol helps you with this task.

```swift
struct State {
  struct PasswordsGroup: ValidationGroup {
    typealias Value = String

    @Validated([
      NotEmptyValidator(errorMessage: "Password field can't be empty").validator
    ])
    var password: String? = nil

    var passwordConfirmation:String? = nil
  }

  @Validated([
    MatchingValidator(errorMessage: "Doesn't match to password").validator
  ])
  var passwordsGroup: PasswordsGroup! = PasswordsGroup()

}
```

### Validations

Call `validate()` method to receive validation errors. This method return an array of `ValidationError`. The `localizedDescription` property of this error matches to the validator's `errorMessage`.

```swift
let errors = $email.validate()
if errors.isEmpty {
    print("Valid")
} else {
    print(errors.map { $0.localizedDescription }.joined(separator: ", "))
}
```
### Validators

There are several predefined validators in the package, but you also can create your own. To do this, you need to conform your validator class (or structure) to the `Validator` protocol. 

```swift
struct YourOwnValidator<Value>: Validator {
    var errorMessage: String = "It is not valid"
    func isValid(valid: Value?) -> Bool {
        // Validate and return true or false
    }
}
```
### iOS 13 and Combine framework.

With iOS 13 Combine framework you can subscribe to your validated property and receive updated validation errors every time the property changes.

```swift
$email
    .publisher
    .map { $0.map { $0.localizedDescription }.joined(separator: ", ") }
    .receive(on: RunLoop.main)
    .assign(to: \.text, on: emailErrorLabel)
    .sore(in: &cancellables)
    
NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
    .compactMap { ($0.object as? UITextField)?.text }
    .assign(to: \.email, on: self)
    .store(in: &cancellables)
```

## Author

alexander-gaidukov, alexander.gaidukov@gmail.com
